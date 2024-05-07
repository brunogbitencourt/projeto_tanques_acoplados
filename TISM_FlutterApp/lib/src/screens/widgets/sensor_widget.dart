import 'package:flutter/material.dart';
import '../../models/sensor.dart'; 
import 'dart:math';
import '../components/sensor_details.dart';

class SensorWidget extends StatelessWidget {
  final Sensor sensor;

  const SensorWidget({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        sensor.description ?? '',
        style: TextStyle(fontSize: 16.0),
      ),
      subtitle: Text(
        'Value: ' + (sensor.analogValue != null ? sensor.analogValue!.toStringAsFixed(2): (sensor.digitalValue != null ? sensor.digitalValue.toString() : '')),
        style: TextStyle(fontSize: 14.0),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SensorDetails(sensor: sensor);
          },
        );
      },
    );
  }
}
