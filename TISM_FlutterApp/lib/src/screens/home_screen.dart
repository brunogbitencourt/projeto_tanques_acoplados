import 'dart:async';
import 'package:appiot/src/db/db.dart';
import 'package:appiot/src/models/actuator.dart';
import 'package:appiot/src/screens/components/actuator_form.dart';
import 'package:flutter/material.dart';
import 'package:appiot/src/api/firebaseapi.dart';
import 'package:appiot/src/models/sensor.dart';
import '../screens/components/bottom_menu.dart';
import 'components/sensor_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Firebaseapi _firebaseapi = Firebaseapi();
  late List<Sensor> _sensorData = [];
  late List<Actuator> _actuatorData = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
    _fetchActuatorData();
    // Atualiza os dados a cada minuto
    _timer = Timer.periodic(Duration(minutes: 60), (timer) {
      if (mounted) {
        // Verifica se o widget ainda está montado
        _fetchSensorData();
        _fetchActuatorData();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela o timer quando o widget é removido
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TISM - Visão Geral do Processo',
          style: TextStyle(
            fontSize: 20, 
            color: Colors.green.shade700, 
            fontWeight: FontWeight.bold, 
          ),
          textAlign: TextAlign.center, 
        ),
      ),
      body: Column(
        children: [
          SensorForm(sensors: _sensorData),
          Divider(
            color: Colors.green.shade700, 
            thickness: 2, 
          ),
          Text(
            // Título para os Atuadores
            'Atuadores',
            style: TextStyle(
              fontSize: 18, // Tamanho da fonte
              color: Colors.green.shade700, // Cor verde
              fontWeight: FontWeight.bold, // Negrito
            ),
          ),
          ActuatorsForm(actuators: _actuatorData),
          Divider(
            color: Colors.green.shade700, 
            thickness: 2, 
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }

  Future<void> _fetchSensorData() async {
    try {
      final sensorInfoList = await _firebaseapi.fetchSensorInfo();
      final sensorDataMap = await _firebaseapi.fetchLastSensorsDataValueMap();

      List<Sensor> newData = [];

      for (var info in sensorInfoList) {
        final sensorData = sensorDataMap[info.id];

        var sensorOut = sensorData != null
            ? Sensor(
                id: info.id,
                description: info.description,
                type: info.type,
                outputPin1: info.outputPin1,
                outputPin2: info.outputPin2,
                timestamp: sensorData.timestamp,
                analogValue: sensorData.analogValue,
                digitalValue: sensorData.digitalValue,
                unit: sensorData.unit,
              )
            : Sensor(
                id: info.id,
                description: info.description,
                type: info.type,
                outputPin1: info.outputPin1,
                outputPin2: info.outputPin2,
              );

        newData.add(sensorOut);

        // Insira os dados no banco de dados
        await Db.insertSensor(Db.database!, sensorOut);
        print("Inseriu no banco na tabela Sensor");
      }

      if (mounted) {
        setState(() {
          _sensorData = newData;
        });
      }
    } catch (e) {
      print('Failed to fetch sensor data: $e');
    }
  }

  Future<void> _fetchActuatorData() async {
  try {
    final actuatorInfoList = await _firebaseapi.fetchActuatorInfo();
    final actuatorDataMap = await _firebaseapi.fetchLastActuatorsDataValueMap();

    List<Actuator> newData = [];

    for (var info in actuatorInfoList) {
      final actuatorData = actuatorDataMap[info.id];

      var actuatorOut = actuatorData != null
          ? Actuator(
              id: info.id,
              description: info.description,
              typeActuator: info.typeActuator,
              outputPin: info.outputPin,
              state: actuatorData.state,
              outputPWM: actuatorData.outputPWM,
              timestamp: actuatorData.timestamp,
              unit: actuatorData.unit,
            )
          : Actuator(
              id: info.id,
              description: info.description,
              typeActuator: info.typeActuator,
              outputPin: info.outputPin
            );

      newData.add(actuatorOut);

      // Insira os dados no banco de dados
      await Db.insertActuator(Db.database!, actuatorOut);
      print("Inseriu no banco na tabela Actuator");
    }

    if (mounted) {
      setState(() {
        _actuatorData = newData;
      });
    }
  } catch (e) {
    print('Failed to fetch actuator data: $e');
  }
}



}
