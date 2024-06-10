namespace TISM_FIREBASE.Models
{
    public class ActuatorData
    {
        public string Id { get; set; }
        public DateTime TimeStamp { get; set; }
        public double OutputPWM { get; set; }
        public int State { get; set; }
        public string Unit { get; set; }

    }
}
