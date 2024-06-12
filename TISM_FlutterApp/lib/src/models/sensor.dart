class Sensor {
  String? id;
  String? description;
  int? type;
  int? outputPin1;
  int? outputPin2;
  DateTime? timestamp;
  double? analogValue;
  bool? digitalValue;
  String? unit;

  Sensor({
    this.id,
    this.description,
    this.type,
    this.outputPin1,
    this.outputPin2,
    this.timestamp,
    this.analogValue,
    this.digitalValue,
    this.unit,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
  return Sensor(
    id: json['id'],
    description: json['description'],
    type: json['type'],
    outputPin1: json['outputPin1'],
    outputPin2: json['outputPin2'],
    timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
    analogValue: (json['analogValue'] as num?)?.toDouble() ?? 0.0, // Convertendo para double
    digitalValue: json['digitalValue'],
    unit: json['unit'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'type': type,
      'outputPin1': outputPin1,
      'outputPin2': outputPin2,
      'timestamp': timestamp!.toIso8601String(),
      'analogValue': analogValue,
      'digitalValue': digitalValue,
      'unit': unit,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toString(),
      'description': description,
      'type': type,
      'outputPin1': outputPin1,
      'outputPin2': outputPin2,
      'analogValue': analogValue,
      'digitalValue': digitalValue == true ? 1 : 0, // SQLite doesn't support boolean directly
      'unit': unit,
    };
  }
}
