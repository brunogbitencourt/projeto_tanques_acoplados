namespace TISM_MQTT.Models
{
    public class Actuator
    {
        public string Id { get; set; }
        public string Description { get; set; }
        public int OutputPin { get; set; }
        public int TypeActuator { get; set; }
        //public ActuatorData Data { get; set; }
    }
}
