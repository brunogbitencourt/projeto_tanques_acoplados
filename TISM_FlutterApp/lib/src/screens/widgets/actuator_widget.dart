import 'package:flutter/material.dart';
import '../../models/actuators.dart'; 
import '../components/actuator_details.dart';

class ActuatorWidget extends StatelessWidget {
  final Actuator actuator;

  const ActuatorWidget({Key? key, required this.actuator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        actuator.description ?? '',
        style: TextStyle(fontSize: 16.0),
      ),
      subtitle: Text(
        'Value: ${actuator.state == 1 ? 'ON' : 'OFF'}',
        style: TextStyle(fontSize: 14.0),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ActatorDetails(actuator: actuator);
          },
        );
      },
    );
  }
}
