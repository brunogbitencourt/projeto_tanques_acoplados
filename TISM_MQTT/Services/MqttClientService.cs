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
        private IMqttClient _mqttClient;
        private IMqttClientOptions _options;

        public MqttClientService(ILogger<MqttClientService> logger)
        {
            _logger = logger;

            var handler = new HttpClientHandler
            {
                // Remove this line in production to ensure proper SSL validation
                ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true
            };
            _httpClient = new HttpClient(handler);
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
            });

            _mqttClient.UseApplicationMessageReceivedHandler(async e =>
            {
                var message = Encoding.UTF8.GetString(e.ApplicationMessage.Payload);
                _logger.LogInformation($"Received message: {message}");

                // Process the received message and send to the appropriate API endpoint
                try
                {
                    var jsonDoc = System.Text.Json.JsonDocument.Parse(message);
                    await ProcessMessage(jsonDoc.RootElement);
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

        public async Task StopAsync(CancellationToken cancellationToken)
        {
            if (_mqttClient != null)
            {
                await _mqttClient.DisconnectAsync();
            }
        }

        public async Task PublishMessageAsync(string topic, string message)
        {
            if (_mqttClient.IsConnected)
            {
                var mqttMessage = new MqttApplicationMessageBuilder()
                    .WithTopic(topic)
                    .WithPayload(message)
                    .WithExactlyOnceQoS()
                    .Build();

                await _mqttClient.PublishAsync(mqttMessage);
            }
        }

        public async Task SubscribeToTopicAsync(string topic)
        {
            if (_mqttClient.IsConnected)
            {
                await _mqttClient.SubscribeAsync(new MqttTopicFilterBuilder().WithTopic(topic).Build());
            }
        }

        private async Task PostSensorToApi(JsonElement sensor)
        {
            var sensorJson = sensor.GetRawText(); // Obtém o JSON do sensor
            var content = new StringContent(sensorJson, Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("https://tismfirebase.azurewebsites.net/api/Sensor", content);
                response.EnsureSuccessStatusCode();
                var responseBody = await response.Content.ReadAsStringAsync();
                _logger.LogInformation($"Successfully posted sensor to API. Response: {responseBody}");
            }
            catch (HttpRequestException ex)
            {
                _logger.LogError(ex, $"Error posting sensor to API. Message: {ex.Message}, Status Code: {ex.StatusCode}");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An unexpected error occurred while posting sensor to the API.");
            }
        }

        private async Task PostSensorDataToApi(JsonElement sensorData)
        {
            var sensorDataJson = sensorData.GetRawText(); // Obtém o JSON dos dados do sensor
            var content = new StringContent(sensorDataJson, Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("https://tismfirebase.azurewebsites.net/api/SensorData", content);
                response.EnsureSuccessStatusCode();
                var responseBody = await response.Content.ReadAsStringAsync();
                _logger.LogInformation($"Successfully posted sensor data to API. Response: {responseBody}");
            }
            catch (HttpRequestException ex)
            {
                _logger.LogError(ex, $"Error posting sensor data to API. Message: {ex.Message}, Status Code: {ex.StatusCode}");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An unexpected error occurred while posting sensor data to the API.");
            }
        }

        private async Task ProcessMessage(JsonElement message)
        {
            if (message.TryGetProperty("devices", out var devicesProperty))
            {
                if (devicesProperty.TryGetProperty("sensors", out var sensorsProperty))
                {
                    foreach (var sensorProperty in sensorsProperty.EnumerateObject())
                    {

                        var id = sensorProperty.Name;
                        var description = sensorProperty.Value.GetProperty("description").GetString();
                        var outputPin1 = sensorProperty.Value.TryGetProperty("OutputPin1", out var outputPin1Property) ? outputPin1Property.GetInt32() : 0;
                        var outputPin2 = sensorProperty.Value.TryGetProperty("OutputPin2", out var outputPin2Property) ? outputPin2Property.GetInt32() : 0;
                        var type = sensorProperty.Value.TryGetProperty("Type", out var typeProperty) ? typeProperty.GetInt32() : 0;

                        // Crie o objeto Sensor com as propriedades extraídas
                        var sensorObj = new Sensor
                        {
                            Id = id,
                            Description = description,
                            OutputPin1 = outputPin1,
                            OutputPin2 = outputPin2,
                            Type = type
                        };

                        var sensorJson = JsonSerializer.Serialize(sensorObj);
                        var jsonElement = JsonDocument.Parse(sensorJson).RootElement;

                        await PostSensorToApi(jsonElement);
                    }
                }
                if (devicesProperty.TryGetProperty("sensors_data", out var sensorsDataProperty))
                {
                    foreach (var sensorDataProperty in sensorsDataProperty.EnumerateObject())
                    {
                        var sensorId = sensorDataProperty.Name;

                        
                        foreach (var timestampProperty in sensorDataProperty.Value.EnumerateObject())
                        {
                            var timestamp = timestampProperty.Name;

                            var id = sensorId;
                            var timestampValue = timestampProperty.Value.GetProperty("TimeStamp").GetDateTime();
                            var analogValue = timestampProperty.Value.TryGetProperty("analogValue", out var AnalogValueProperty) ? AnalogValueProperty.GetDouble() : 0;
                            var digitalValue = timestampProperty.Value.TryGetProperty("digitalValue", out var DigitalValueProperty) ? DigitalValueProperty.GetBoolean() : false;
                            var unit = timestampProperty.Value.GetProperty("unit").GetString();

                            var sensorDataObj = new SensorData
                            {
                                Id = id,
                                Timestamp = timestampValue,
                                AnalogValue = analogValue,
                                DigitalValue = digitalValue, 
                                Unit = unit
                            };

                            var sensorJson = JsonSerializer.Serialize(sensorDataObj);
                            var jsonElement = JsonDocument.Parse(sensorJson).RootElement;

                            await PostSensorDataToApi(jsonElement);
                        }
                    }
                }
            }
            else
            {
                _logger.LogWarning("Received message does not contain the expected structure.");
            }
        }





    }
}
