import 'package:flutter/material.dart';
import '../../models/sensor.dart'; // Importe a classe Sensor
import '../widgets/sensor_widget.dart'; // Importe o widget SensorWidget

class SensorForm extends StatelessWidget {
  final List<Sensor> sensors;

  const SensorForm({
    Key? key,
    required this.sensors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center( // Centraliza o título "Leitura de Sensores"
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Leitura de Sensores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ),
        Center( // Centraliza a linha verde
          child: Container(
            height: 2,
            color: Colors.green.shade700,
            margin: EdgeInsets.only(bottom: 8),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: sensors
                    .sublist(0, sensors.length ~/ 2) // Sensores na primeira coluna
                    .map((sensor) => SensorWidget(sensor: sensor))
                    .toList(),
              ),
            ),
            Expanded(
              child: Column(
                children: sensors
                    .sublist(sensors.length ~/ 2) // Sensores na segunda coluna
                    .map((sensor) => SensorWidget(sensor: sensor))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
