class SensorData {
  String? id;
  DateTime? timestamp;
  double? analogValue;
  bool? digitalValue;
  String? unit;

  SensorData({
    this.id,
    this.timestamp,
    this.analogValue,
    this.digitalValue,
    this.unit,
  });

  SensorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = DateTime.parse(json['timestamp']);
    analogValue = json['analogValue'];
    digitalValue = json['digitalValue'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timestamp'] = timestamp?.toIso8601String();
    data['analogValue'] = analogValue;
    data['digitalValue'] = digitalValue;
    data['unit'] = unit;
    return data;
  }
}
