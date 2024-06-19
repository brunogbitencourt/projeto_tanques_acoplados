using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MQTTnet;
using MQTTnet.Client;
using MQTTnet.Client.Options;
using System;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using TISM_MQTT.Models;

namespace TISM_MQTT.Services
{
    public class MqttClientService : IHostedService
    {
        private readonly ILogger<MqttClientService> _logger;
        private readonly HttpClient _httpClient;
        private readonly FirebaseClient firebaseClient;
        private IMqttClient _mqttClient;
        private IMqttClientOptions _options;

        public MqttClientService(ILogger<MqttClientService> logger, FirebaseClient firebaseClient)
        {
            _logger = logger;

            var handler = new HttpClientHandler
            {
                // Remove this line in production to ensure proper SSL validation
                ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true
            };
            _httpClient = new HttpClient(handler);

            this.firebaseClient = firebaseClient;
        }

        public async Task StartAsync(CancellationToken cancellationToken)
        {
            var mqttFactory = new MqttFactory();
            _mqttClient = mqttFactory.CreateMqttClient();

            _options = new MqttClientOptionsBuilder()
                .WithClientId("IoT_PUC_SG_mqtt11")
                .WithTcpServer("test.mosquitto.org", 1883)
                .WithCleanSession()
                .Build();

            _mqttClient.UseConnectedHandler(async e =>
            {
                _logger.LogInformation("Connected to MQTT broker");
                await _mqttClient.SubscribeAsync(new MqttTopicFilterBuilder().WithTopic("sensors/data").Build());
                _logger.LogInformation("Subscribed to topic sensors/data");
                await _mqttClient.SubscribeAsync(new MqttTopicFilterBuilder().WithTopic("actuators/data").Build());
                _logger.LogInformation("Subscribed to topic actuators/data");
            });

            _mqttClient.UseApplicationMessageReceivedHandler(async e =>
            {
                var topic = e.ApplicationMessage.Topic;
                var message = Encoding.UTF8.GetString(e.ApplicationMessage.Payload);
                _logger.LogInformation($"Received message: {message}");

                try
                {
                    var jsonDoc = System.Text.Json.JsonDocument.Parse(message);
                    switch (topic)
                    {
                        case "sensors/data":
                            await ProcessSensorData(jsonDoc.RootElement);
                            break;
                        case "actuators/data":
                            await ProcessActuatorData(jsonDoc.RootElement);
                            break;
                        default:
                            _logger.LogWarning($"Received message from unknown topic: {topic}");
                            break;
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing message");
                }
            });

            try
            {
                await _mqttClient.ConnectAsync(_options, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Connection failed");
            }
        }

        private async Task ProcessActuatorData(JsonElement rootElement)
        {
            try
            {
                ActuatorData actuatorData = JsonSerializer.Deserialize<ActuatorData>(rootElement.GetRawText());

                if (actuatorData == null)
                {
                    _logger.LogWarning("Received message does not contain actuator data.");
                    return;
                }

                var formattedTimestamp = actuatorData.Timestamp.ToString("yyyy-MM-dd HH:mm:ss");

                await firebaseClient
                    .Child("/devices/actuators_data")
                    .Child(actuatorData.Id)
                    .Child(formattedTimestamp)
                    .PutAsync(actuatorData);

                _logger.LogInformation($"Actuator Data {actuatorData.Id} inserted into Firebase");

            }
            catch (FirebaseException ex)
            {
                _logger.LogError(ex, "Error processing and inserting actuator into Firebase");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing and inserting actuator into Firebase");
            }

        }

        private async Task ProcessSensorData(JsonElement rootElement)
        {
            try
            {

                SensorData sensorData = JsonSerializer.Deserialize<SensorData>(rootElement.GetRawText());

                if (sensorData == null)
                {
                    _logger.LogWarning("Received message does not contain sensor data.");
                    return;
                }

                var formattedTimestamp = sensorData.Timestamp.ToString("yyyy-MM-dd HH:mm:ss");

                await firebaseClient
                    .Child("/devices/sensors_data")
                    .Child(sensorData.Id)
                    .Child(formattedTimestamp)
                    .PutAsync(sensorData);

                _logger.LogInformation($"Sensor Data {sensorData.Id} inserted into Firebase");

            }
            catch(FirebaseException ex)
            {
                _logger.LogError(ex, "Error processing and inserting sensor into Firebase");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing and inserting sensor into Firebase");
            }

        }

        public async Task StopAsync(CancellationToken cancellationToken)
        {
            if (_mqttClient != null)
            {
                await _mqttClient.DisconnectAsync();
            }
        }

        public async Task<bool> PublishMessageAsync(string topic, string message)
        {
            if (_mqttClient.IsConnected)
            {
                try
                {
                    var mqttMessage = new MqttApplicationMessageBuilder()
                        .WithTopic(topic)
                        .WithPayload(message)
                        .WithExactlyOnceQoS()
                        .Build();

                    await _mqttClient.PublishAsync(mqttMessage);
                    _logger.LogInformation($"Message published to topic {topic}: {message}");
                    return true;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, $"Failed to publish message to topic {topic}");
                }
            }
            else
            {
                _logger.LogWarning("MQTT client is not connected");
            }
            return false;
        }

        public async Task SubscribeToTopicAsync(string topic)
        {
            if (_mqttClient.IsConnected)
            {
                await _mqttClient.SubscribeAsync(new MqttTopicFilterBuilder().WithTopic(topic).Build());
            }
        }

    }
}
