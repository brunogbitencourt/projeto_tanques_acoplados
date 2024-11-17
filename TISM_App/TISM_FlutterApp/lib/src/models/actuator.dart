class Actuator {
  String? id;
  String? description;
  int? outputPin;
  double? outputPWM;
  DateTime? timestamp;
  String? unit;

  Actuator({
    this.id,
    this.description,
    this.outputPin,
    this.outputPWM,
    this.timestamp,
    this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'outputPin': outputPin,
      'outputPWM': outputPWM,
      'timestamp': timestamp?.toIso8601String(),
      'unit': unit,
    };
  }

  Actuator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    outputPin = json['outputPin'];
    outputPWM = (json['outputPWM'] as num?)?.toDouble();
    timestamp = DateTime.tryParse(json['timeStamp'] ?? '');
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['outputPin'] = outputPin;
    data['outputPWM'] = outputPWM;
    data['timestamp'] = timestamp!.toIso8601String();
    data['unit'] = unit;
    return data;
  }
}
