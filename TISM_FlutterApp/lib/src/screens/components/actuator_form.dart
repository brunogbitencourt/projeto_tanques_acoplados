import 'package:flutter/material.dart';
import '../../models/actuators.dart'; // Importe a classe Sensor
import '../widgets/actuator_widget.dart'; // Importe o widget SensorWidget


class ActuatorsForm extends StatelessWidget {
  final List<Actuator> actuators;

  const ActuatorsForm({
    Key? key,
    required this.actuators,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: actuators
                .sublist(0, actuators.length ~/ 2) // Sensores na primeira coluna
                .map((actuator) => ActuatorWidget(actuator: actuator))
                .toList(),
          ),
        ),
        Expanded(
          child: Column(
            children: actuators
                .sublist(actuators.length ~/ 2) // Sensores na segunda coluna
                .map((actuator) => ActuatorWidget(actuator: actuator))
                .toList(),
          ),
        ),
      ],
    );
  }
}
