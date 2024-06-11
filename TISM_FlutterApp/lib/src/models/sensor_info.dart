import 'package:appiot/src/models/sensor.dart';
import 'package:appiot/src/models/sensor_data.dart';

class SensorInfo {
   String? id;
  String? description;
  int? type;
  int? outputPin1;
  int? outputPin2;

  SensorInfo({
    this.id,
    this.description,
    this.type,
    this.outputPin1,
    this.outputPin2
  });

  factory SensorInfo.fromJson(Map<String, dynamic> json) {
    return SensorInfo(
      id: json['id'],
      description: json['description'],
      type: json['type'],
      outputPin1: json['outputPin1'],
      outputPin2: json['outputPin2']
    );
  }
 
}
