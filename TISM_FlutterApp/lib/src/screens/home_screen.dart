import 'package:flutter/material.dart';
import '../screens/components/bottom_menu.dart'; // Importe a classe BottomMenu
import '../models/sensor.dart'; // Importe a classe Sensor
import '../screens/components/sensor_form.dart';
import '../models/actuators.dart';
import '../screens/components/actuator_form.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Sensor> sensors = [
      Sensor(id: 1, description: 'Ultrasonic Sensor - Tank 01', type: 1, outPutPin1: 31, outPutPin2: 32, analogValue: 20.0, digitalValue: null, timeStamp: DateTime.now()),
      Sensor(id: 2, description: 'Ultrasonic Sensor - Tank 02', type: 1, outPutPin1: 33, outPutPin2: 34, analogValue: 20.0, digitalValue: null, timeStamp: DateTime.now()),
      Sensor(id: 3, description: 'Ultrasonic Sensor - Reservoir', type: 1, outPutPin1: 35, outPutPin2: 36, analogValue: 20.0, digitalValue: null, timeStamp: DateTime.now()),
      Sensor(id: 4, description: 'Digital Level Sensor - Tank 01', type: 2, outPutPin1: 1, outPutPin2: 3, analogValue: null, digitalValue: false, timeStamp: DateTime.now()),
      Sensor(id: 5, description: 'Digital Level Sensor - Tank 02', type: 2, outPutPin1: 2, outPutPin2: 4, analogValue: null, digitalValue: false, timeStamp: DateTime.now()),   
      Sensor(id: 6, description: 'Digital Level Sensor - Reservoir', type: 2, outPutPin1: 3, outPutPin2: 5, analogValue: null, digitalValue: false, timeStamp: DateTime.now()),
    ];

    List<Actuator> actuators = [
      Actuator(id: 1, description: 'Pump 01', type: 1, outPutPin: 1, pwmOutput: 2, state: 0, timeStamp: DateTime.now()),
      Actuator(id: 2, description: 'Pump 02', type: 1, outPutPin: 3, pwmOutput: 4, state: 1, timeStamp: DateTime.now()),
      Actuator(id: 3, description: 'Pump 03', type: 1, outPutPin: 5, pwmOutput: 6, state: 0, timeStamp: DateTime.now()),
      Actuator(id: 4, description: 'Valve 01', type: 2, outPutPin: 7, pwmOutput: 8, state: 0, timeStamp: DateTime.now()),
      Actuator(id: 5, description: 'Valve 02', type: 2, outPutPin: 9, pwmOutput: 10, state: 1, timeStamp: DateTime.now()),
      
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Vision of the System'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Sensors',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),

          SensorForm(sensors: sensors),
          
          Divider(),
          
          Text(
            'Actuators',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          
          ActuatorsForm(actuators: actuators),
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
