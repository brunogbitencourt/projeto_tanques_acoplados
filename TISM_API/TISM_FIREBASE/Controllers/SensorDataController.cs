using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.AspNetCore.Mvc;
using TISM_FIREBASE.Models;

namespace TISM_FIREBASE.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SensorDataController : Controller
    {
        private readonly FirebaseClient firebaseClient;
        private const string CollectionName = "/devices/sensors_data";

        public SensorDataController(FirebaseClient firebaseClient)
        {
            this.firebaseClient = firebaseClient;
        }

        [HttpGet]
        public async Task<IActionResult> GetActuatorData(string id)
        {
            var sensorDatas = await firebaseClient
                .Child(CollectionName)
                .Child(id)
                .OnceAsync<SensorData>();


            var sensorDataList = sensorDatas.Select(b => new SensorData
            {
                Id = id,
                Timestamp = b.Object.Timestamp,
                AnalogValue = b.Object.AnalogValue,
                DigitalValue = b.Object.DigitalValue,
                Unit = b.Object.Unit
            }).ToList();

            return Ok(sensorDataList);

        }

        [HttpPost]
        public async Task<IActionResult> InsertActuatorData([FromBody] SensorData sensorData)
        {
            if (sensorData == null)
            {
                return BadRequest("The sensorData object is required.");
            }

            if (string.IsNullOrEmpty(sensorData.Id))
            {
                return BadRequest("Id is required.");
            }

            try
            {
                string formattedTimestamp = sensorData.Timestamp.ToString("yyyy-MM-dd HH:mm:ss");

                await firebaseClient
                    .Child("devices")
                    .Child("sensors_data")
                    .Child(sensorData.Id)
                    .Child(formattedTimestamp)
                    .PutAsync(sensorData);

                return CreatedAtAction(nameof(GetActuatorData), new { id = sensorData.Id, timestamp = sensorData.Timestamp }, sensorData);
            }
            catch (Exception ex)
            {              
                return StatusCode(500, $"Error while writing data to Firebase: {ex.Message}");
            }
        }



        [HttpGet("lastValue/{id}")]
        public async Task<IActionResult> GetSensorLastValue(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return BadRequest($"Sensor {id} doesn't exist");
            }

            var queryFB = await firebaseClient
                .Child("devices")
                .Child("sensors_data")
                .Child(id)
                .OrderByKey()
                .LimitToLast(1)
                .OnceAsync<SensorData>();

            if (queryFB == null || !queryFB.Any())
            {
                return NotFound($"No data found for sensor {id}");
            }

            var lastSensorData = queryFB.LastOrDefault();

            if (lastSensorData == null)
            {
                return NotFound($"No data found for sensor {id}");
            }

            var result = new
            {
                key = lastSensorData.Key,
                dataResult = lastSensorData.Object 
            };

            return Ok(result);
        }

        [HttpGet("lastValues")]
        public async Task<IActionResult> GetLastValuesForAllSensors()
        {
            // Assume que existe um método que busca todos os sensores registrados
            var sensors = await GetAllSensorsAsync();

            if (sensors == null || !sensors.Any())
            {
                return NotFound("No sensors found.");
            }

            var tasks = sensors.Select(async sensor =>
            {
                var queryFB = await firebaseClient
                    .Child("devices")
                    .Child("sensors_data")
                    .Child(sensor.Id)
                    .OrderByKey()
                    .LimitToLast(1)
                    .OnceAsync<SensorData>();

                var lastSensorData = queryFB.LastOrDefault();

                return new
                {
                    SensorId = sensor.Id,
                    Data = lastSensorData?.Object
                };
            });

            var results = await Task.WhenAll(tasks);

            var response = results
                .Where(result => result.Data != null)
                .ToDictionary(result => result.SensorId, result => result.Data);

            return Ok(response);
        }

        private async Task<List<Sensor>> GetAllSensorsAsync()
        {
            var sensors = await firebaseClient
                .Child("devices")
                .Child("sensors")
                .OnceAsync<Sensor>();

            return sensors.Select(sensor => sensor.Object).ToList();
        }




    }
}

