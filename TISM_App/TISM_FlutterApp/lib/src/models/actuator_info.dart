class ActuatorInfo {
  String? id;
  String? description;
  int? outputPin;

  ActuatorInfo({
    this.id,
    this.description,
    this.outputPin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'outputPin': outputPin,
    };
  }

  ActuatorInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    outputPin = json['outputPin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['outputPin'] = outputPin;
    return data;
  }
}
