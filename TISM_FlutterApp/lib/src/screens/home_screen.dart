import 'package:flutter/material.dart';
import 'package:appiot/src/db/db.dart';
import '../screens/components/bottom_menu.dart'; // BottomMenu import
import '../models/sensor.dart'; // Sensor import
import '../models/actuators.dart'; // Actuator import
import '../screens/components/sensor_form.dart'; // SensorForm import
import '../screens/components/actuator_form.dart'; // ActuatorsForm import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Sensor>> _fetchSensors() async {
    // Simulating database operations
    var sensorsType = [1, 2, 3, 4, 5, 6];
    List<Sensor> sensors = [];
    
    for (var sensorType in sensorsType) {
      print('Fetching sensor of type $sensorType');
      await Db.insertExampleData(Db.database, sensorType);
    }

    for (var sensorType in sensorsType) {
      print('Fetching sensor of type $sensorType');
      sensors.add(await Db.getLastSensorByType(sensorType));
    }

    return sensors;
  }

  Future<List<Actuator>> _fetchActuators() async {
    return [
      Actuator(id: 1, description: 'Pump 01', type: 1, outPutPin: 1, pwmOutput: 2, state: 0, timeStamp: DateTime.now()),
      Actuator(id: 2, description: 'Pump 02', type: 1, outPutPin: 3, pwmOutput: 4, state: 1, timeStamp: DateTime.now()),
      Actuator(id: 3, description: 'Pump 03', type: 1, outPutPin: 5, pwmOutput: 6, state: 0, timeStamp: DateTime.now()),
      Actuator(id: 4, description: 'Valve 01', type: 2, outPutPin: 7, pwmOutput: 8, state: 0, timeStamp: DateTime.now()),
      Actuator(id: 5, description: 'Valve 02', type: 2, outPutPin: 9, pwmOutput: 10, state: 1, timeStamp: DateTime.now()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Vision of the System'),
      ),
      body: FutureBuilder<List<Sensor>>(
        future: _fetchSensors(),
        builder: (BuildContext context, AsyncSnapshot<List<Sensor>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Sensor> sensors = snapshot.data ?? [];
            return Column(
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
                FutureBuilder<List<Actuator>>(
                  future: _fetchActuators(),
                  builder: (BuildContext context, AsyncSnapshot<List<Actuator>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Actuator> actuators = snapshot.data ?? [];
                      return ActuatorsForm(actuators: actuators);
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
