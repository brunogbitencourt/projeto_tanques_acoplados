using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.AspNetCore.Mvc;
using System.Collections;
using TISM_MQTT.Models;

namespace TISM_MQTT.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class FirebaseController : Controller
    {

        private readonly FirebaseClient firebaseClient;

        public FirebaseController(FirebaseClient firebaseClient)
        {
            this.firebaseClient = firebaseClient;
        }


        [HttpPost("actuator")]
        public async Task<IActionResult> InsertActuator([FromBody] Actuator actuator)
        {
            if (string.IsNullOrEmpty(actuator.Id))
            {
                return BadRequest("Id is required");
            }

            try
            {
                await firebaseClient
                    .Child("/devices/actuators")
                    .Child(actuator.Id)
                    .PutAsync(actuator);

                return Ok();

            }
            catch (FirebaseException ex)
            {
                return StatusCode(500, "A Firebase error occurred while processing your request."+ex.Message);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while processing actuator {actuator.Id}: {ex.Message}");
                
            }              
        }

        [HttpPost("actuator_data")]
        public async Task<IActionResult> InsertActuatorData([FromBody] ActuatorData actuatorData)
        {
            if (string.IsNullOrEmpty(actuatorData.Id))
            {
                return BadRequest("Id is required");
            }

            string formattedTimestamp = actuatorData.Timestamp.ToString("yyyy-MM-dd HH:mm:ss");

            try
            {
                await firebaseClient
                    .Child("/devices/actuators_data")
                    .Child(actuatorData.Id)
                    .Child(formattedTimestamp.ToString())
                    .PutAsync(actuatorData);

                return Ok();
            }
            catch (FirebaseException ex)
            {
                return StatusCode(500, "A Firebase error occurred while processing your request."+ex.Message);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while processing actuator data {actuatorData.Id}: {ex.Message}");
                
            }              
        }


        [HttpPost("sensor")]
        public async Task<IActionResult> InsertSensor([FromBody] Sensor sensor)
        {
            if (string.IsNullOrEmpty(sensor.Id))
            {
                return BadRequest("Id is required");
            }

            try
            {
                await firebaseClient
                    .Child("/devices/sensors")
                    .Child(sensor.Id)
                    .PutAsync(sensor);

                return Ok();

            }
            catch (FirebaseException ex)
            {
                return StatusCode(500, "A Firebase error occurred while processing your request."+ex.Message);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while processing sensor {sensor.Id}: {ex.Message}");
                
            }              
        }

        [HttpPost("sensor_data")]
        public async Task<IActionResult> InsertSensorData([FromBody] SensorData sensorData)
        {
            if (string.IsNullOrEmpty(sensorData.Id))
            {
                return BadRequest("Id is required");
            }

            string formattedTimestamp = sensorData.Timestamp.ToString("yyyy-MM-dd HH:mm:ss");

            try
            {
                await firebaseClient
                    .Child("/devices/sensors_data")
                    .Child(sensorData.Id)
                    .Child(formattedTimestamp.ToString())
                    .PutAsync(sensorData);

                return Ok();
            }
            catch (FirebaseException ex)
            {
                return StatusCode(500, "A Firebase error occurred while processing your request."+ex.Message);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while processing sensor data {sensorData.Id}: {ex.Message}");
                
            }              
        }




    }
}
