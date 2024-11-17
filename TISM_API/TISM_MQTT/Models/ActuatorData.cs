namespace TISM_MQTT.Models
{
    public class ActuatorData
    {
        public string Id { get; set; }
        public DateTime Timestamp { get; set; }
        public double PwmOutput { get; set; }
        public int State { get; set; }
        public string Unit { get; set; }

    }
}
