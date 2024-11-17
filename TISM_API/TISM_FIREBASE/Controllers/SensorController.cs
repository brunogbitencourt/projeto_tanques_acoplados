using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.AspNetCore.Mvc;
using TISM_FIREBASE.Models;

namespace TISM_FIREBASE.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SensorController : Controller
    {
        private readonly FirebaseClient firebaseClient;
        private const string CollectionName = "/devices/sensors";

        public SensorController(FirebaseClient firebaseClient)
        {
            this.firebaseClient = firebaseClient;
        }

        [HttpGet]
        public async Task<IActionResult> GetSensors()
        {
            var sensors = await firebaseClient
                .Child(CollectionName)
                .OnceAsync<Sensor>();

            var sensorList = sensors.Select(b => new Sensor
            {
                Id = b.Key,
                Description = b.Object.Description,
                OutputPin1 = b.Object.OutputPin1,
                OutputPin2 = b.Object.OutputPin2,
                Type = b.Object.Type

            }).ToList();

            return Ok(sensorList);
        }

        [HttpPost]
        public async Task<IActionResult> InsertSensor([FromBody] Sensor sensor)
        {
            if (string.IsNullOrEmpty(sensor.Id))
            {
                return BadRequest("Id is required");
            }

            string sensorId = sensor.Id;

            await firebaseClient
                .Child(CollectionName)
                .Child(sensorId)
                .PutAsync(sensor);

            return CreatedAtAction(nameof(GetSensors), new { id = sensor.Id }, sensor);

        }



    }
}