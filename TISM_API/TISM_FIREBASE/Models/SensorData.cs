namespace TISM_FIREBASE.Models
{
    public class SensorData
    {
        public string Id { get; set; }
        public DateTime Timestamp { get; set; }
        public double AnalogValue { get; set; }
        public bool DigitalValue { get; set; }
        public string Unit { get; set; }


    }
}
