class ActuatorData{
  int? id;
  int? pwmOutput;
  DateTime? timeStamp;
  String? unit;

  ActuatorData({
    this.id,  
    this.pwmOutput, 
    this.timeStamp, 
    this.unit
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pwmOutput': pwmOutput,
      'timeStamp': timeStamp?.toIso8601String(),
      'unit': unit,
    };
  }


 ActuatorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pwmOutput = json['pwmOutput'];
    timeStamp = DateTime.parse(json['timeStamp']);
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pwmOutput'] = pwmOutput;
    data['timeStamp'] = timeStamp!.toIso8601String();
    data['unit'] = unit;
    return data;
  }

  


}