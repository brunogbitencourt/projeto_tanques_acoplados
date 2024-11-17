using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.AspNetCore.Mvc;
using TISM_FIREBASE.Models;

namespace TISM_FIREBASE.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ActuatorDataController : Controller
    {
        private readonly FirebaseClient firebaseClient;
        private const string CollectionName = "/devices/actuators_data";

        public ActuatorDataController(FirebaseClient firebaseClient)
        {
            this.firebaseClient = firebaseClient;
        }

        [HttpGet]
        public async Task<IActionResult> GetActuatorData(string id)
        {
            var actuatorDatas = await firebaseClient
                .Child(CollectionName)
                .Child(id)
                .OnceAsync<ActuatorData>();


            var actuatorDataList = actuatorDatas.Select(b => new ActuatorData
            {
                Id = id,
                TimeStamp = b.Object.TimeStamp,
                OutputPWM = b.Object.OutputPWM,
                State = b.Object.State,
                Unit = b.Object.Unit
            }).ToList();

            return Ok(actuatorDataList);

        }

        [HttpPost]
        public async Task<IActionResult> InsertActuatorData([FromBody] ActuatorData actuatorData)
        {
            if (string.IsNullOrEmpty(actuatorData.Id))
            {
                return BadRequest("Id is required");
            }


            string formattedTimestamp = actuatorData.TimeStamp.ToString("yyyy-MM-dd HH:mm:ss");

            await firebaseClient
                .Child(CollectionName)
                .Child(actuatorData.Id)
                .Child(formattedTimestamp.ToString())
                .PutAsync(actuatorData);

            return CreatedAtAction(nameof(GetActuatorData), new { id = actuatorData.Id, timeStamp = actuatorData.TimeStamp }, actuatorData);

        }

        [HttpGet("lastValue/{id}")]
        public async Task<IActionResult> GetActuatorLastValue(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return BadRequest("Actuator Id is invalid");
            }

            try
            {
                var queryFB = await firebaseClient
                    .Child(CollectionName)
                    .Child(id)
                    .OrderByKey()
                    .LimitToLast(1)
                    .OnceAsync<ActuatorData>();

                if (queryFB == null || queryFB.Any())
                {
                    return BadRequest($"No data found for actuator {id}");
                }

                var lastActuatorData = queryFB.LastOrDefault();                

                var result = new
                {
                    key = lastActuatorData.Key,
                    dataResult = lastActuatorData.Object
                };

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error whilhe selecting data from Firebase: {ex.Message}");
            }
        }

        [HttpGet("lastValues")]
        public async Task<IActionResult> GetActuatorsValues()
        {
            var actuators = await GetAllActuatorsAsync();

            if (actuators == null || !actuators.Any())
            {
                return NotFound("No actuators found");
            }

            var tasks = actuators.Select(async actuator =>
            {
                var queryFB = await firebaseClient
                    .Child(CollectionName)
                    .Child(actuator.Id)
                    .OrderByKey()
                    .LimitToLast(1)
                    .OnceAsync<ActuatorData>();

                var lastActuatorData = queryFB.LastOrDefault();

                return new
                {
                    ActuatorId = actuator.Id,
                    Data = lastActuatorData?.Object // Note the null-conditional operator here
                };
            });

            var results = await Task.WhenAll(tasks);

            var response = results
                .Where(result => result.Data != null)
                .ToDictionary(result => result.ActuatorId, result => result.Data);

            return Ok(response);
        }


        private async Task<List<Actuator>> GetAllActuatorsAsync()
        {
            var actuators = await firebaseClient
                .Child("devices")
                .Child("actuators")
                .OnceAsync<Actuator>();

            return actuators.Select(actuator => actuator.Object).ToList();
        }
    }
}