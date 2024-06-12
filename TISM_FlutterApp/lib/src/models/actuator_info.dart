class ActuatorInfo{
  String? id;
  String? description;  
  int? outputPin;
  int? typeActuator;

  ActuatorInfo({
    this.id, 
    this.description, 
    this.typeActuator, 
    this.outputPin
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'typeActuator': typeActuator,
      'outputPin': outputPin
    };
  }

 ActuatorInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    typeActuator = json['typeActuator'];
    outputPin = json['outputPin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['description'] = description;
    data['typeActuator'] = typeActuator;
    data['outputPin'] = outputPin;
    return data;
  }
}