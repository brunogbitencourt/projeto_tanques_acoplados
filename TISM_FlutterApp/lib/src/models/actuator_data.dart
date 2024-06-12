class ActuatorData{
  int? id;
  int? state;
  int? pwmOutput;
  DateTime? timeStamp;
  String? unit;

  ActuatorData({
    this.id, 
    this.state, 
    this.pwmOutput, 
    this.timeStamp, 
    this.unit
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'state': state,
      'pwmOutput': pwmOutput,
      'timeStamp': timeStamp?.toIso8601String(),
      'unit': unit,
    };
  }


 ActuatorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    pwmOutput = json['pwmOutput'];
    timeStamp = DateTime.parse(json['timeStamp']);
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['state'] = state;
    data['pwmOutput'] = pwmOutput;
    data['timeStamp'] = timeStamp!.toIso8601String();
    data['unit'] = unit;
    return data;
  }

  


}