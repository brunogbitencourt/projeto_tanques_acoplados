class Actuator{
  String? id;
  String? description;  
  int? outputPin;
  int? typeActuator;
  int? state;
  double? outputPWM;
  DateTime? timestamp;
  String? unit;

  Actuator({
    this.id, 
    this.description, 
    this.typeActuator, 
    this.outputPin, 
    this.state, 
    this.outputPWM, 
    this.timestamp, 
    this.unit
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'typeActuator': typeActuator,
      'outputPin': outputPin,
      'state': state,
      'outputPWM': outputPWM,
      'timestamp': timestamp?.toIso8601String(),
      'unit': unit,
    };
  }


 Actuator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    typeActuator = json['typeActuator'];
    outputPin = json['outputPin'];
    state = json['state'];
    outputPWM = (json['outputPWM'] as num?)?.toDouble() ?? 0.0;
    timestamp = DateTime.tryParse(json['timeStamp'] ?? '');                 
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['description'] = description;
    data['typeActuator'] = typeActuator;
    data['outputPin'] = outputPin;
    data['state'] = state;
    data['outputPWM'] = outputPWM;
    data['timestamp'] = timestamp!.toIso8601String();
    data['unit'] = unit;
    return data;
  }

  


}