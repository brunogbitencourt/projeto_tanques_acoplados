import 'dart:async';
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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
    // Atualiza os dados a cada minuto
    _timer = Timer.periodic(Duration(minutes: 60), (timer) {
      if (mounted) { // Verifica se o widget ainda está montado
        _fetchSensorData();
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
            fontSize: 20, // Tamanho da fonte
            color: Colors.green.shade700, // Cor verde
            fontWeight: FontWeight.bold, // Negrito
          ),
          textAlign: TextAlign.center, // Alinhamento centralizado
        ),
      ),
      body: Column(
        children: [
          SensorForm(sensors: _sensorData),
          Divider( // Adiciona uma linha entre os formulários e o próximo título
            color: Colors.green.shade700, // Cor verde
            thickness: 2, // Espessura da linha
          ),
          Text( // Título para os Atuadores
            'Atuadores',
            style: TextStyle(
              fontSize: 18, // Tamanho da fonte
              color: Colors.green.shade700, // Cor verde
              fontWeight: FontWeight.bold, // Negrito
            ),
          ),
          // Aqui você pode adicionar mais widgets para os atuadores
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }

  Future<void> _fetchSensorData() async {
  try {
    final sensorInfoList = await _firebaseapi.fetchSensorInfo();
    final sensorDataMap = await _firebaseapi.fetchLastSensorsDataValueMap();

    final List<Sensor> newData = sensorInfoList.map((info) {
      final sensorData = sensorDataMap[info.id];
      return sensorData != null
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
    }).toList();

    if (mounted) {
      setState(() {
        _sensorData = newData;
      });
    }
  } catch (e) {
    print('Failed to fetch sensor data: $e');
  }
}


}
