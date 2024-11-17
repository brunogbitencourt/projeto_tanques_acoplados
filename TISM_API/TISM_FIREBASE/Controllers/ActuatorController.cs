using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.AspNetCore.Mvc;
using TISM_FIREBASE.Models;

namespace TISM_FIREBASE.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ActuatorController : Controller
    {

        private readonly FirebaseClient firebaseClient;
        private const string CollectionName = "/devices/actuators";

        public ActuatorController(FirebaseClient firebaseClient)
        {
            this.firebaseClient = firebaseClient;
        }

        [HttpGet]
        public async Task<IActionResult> GetActuators()
        {
            var actuators = await firebaseClient
                .Child(CollectionName)
                .OnceAsync<Actuator>();

            var actuatorList = actuators.Select(b => new Actuator
            {
                Id = b.Key,
                Description = b.Object.Description,
                OutputPin = b.Object.OutputPin,
                TypeActuator = b.Object.TypeActuator
            }).ToList();

            return Ok(actuatorList);
        }

        [HttpPost]
        public async Task<IActionResult> InsertActuator([FromBody] Actuator actuator)
        {
            if (string.IsNullOrEmpty(actuator.Id))
            {
                return BadRequest("Id is required");
            }

            string actuatorId = actuator.Id;


            await firebaseClient
                .Child(CollectionName)
                .Child(actuatorId)
                .PutAsync(actuator);

            return CreatedAtAction(nameof(GetActuators), new { id = actuator.Id }, actuator);
        }

        [HttpDelete("id")]
        public async Task<IActionResult> DeleteActuator(string id)
        {
            var existngActuator = await firebaseClient
                .Child(CollectionName)
                .Child(id)
                .OnceSingleAsync<Actuator>();

            if (existngActuator == null)
            {
                return NotFound();
            }

            await firebaseClient
                .Child(CollectionName)
                .Child(id)
                .DeleteAsync();

            return NoContent();

        }




    }
}
