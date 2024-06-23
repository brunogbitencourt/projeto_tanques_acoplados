import 'dart:async';
import 'package:appiot/src/db/db.dart';
import 'package:appiot/src/models/actuator.dart';
import 'package:appiot/src/models/sensor.dart';
import 'package:flutter/material.dart';
import '../screens/components/bottom_menu.dart';
import 'components/actuator_form.dart';
import 'components/sensor_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Sensor> _sensorData = [];
  late List<Actuator> _actuatorData = [];
  late Timer _updateTimer;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    // Atualiza os dados a cada 60 minutos
    _updateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        _loadInitialData();
      }
    });
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final List<Sensor> sensors = await Db.getLastValuePerSensor(Db.database!);
      final List<Actuator> actuators = await Db.getLastValuePerActuator(Db.database!);

      if (mounted) {
        setState(() {
          _sensorData = sensors;
          _actuatorData = actuators;
        });
      }
    } catch (e) {
      print('Failed to fetch initial data: $e');
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SensorForm(sensors: _sensorData),
              Divider(
                color: Colors.green.shade700,
                thickness: 2,
              ),
              Text(
                'Atuadores',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ActuatorsForm(actuators: _actuatorData),
              Divider(
                color: Colors.green.shade700,
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
