import 'dart:async';
import 'package:flutter/material.dart';
import 'package:appiot/src/db/db.dart';
import 'package:appiot/src/models/sensor.dart';
import 'package:appiot/src/models/actuator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appiot/src/api/firebaseapi.dart';
import 'src/screens/login_screen.dart'; // Altere o caminho conforme necessário
import 'src/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Certifique-se de que o Flutter foi inicializado

  try {
    Db.database = await Db.connect(); // Conecta ao banco de dados
  } catch (e) {
    print("Erro ao conectar ao banco de dados: $e");
  }

  try {
    //await LoadInitialDataSensor(); // Conecta ao banco de dados
  } catch (e) {
    print("Erro ao carregar dados sensores: $e");
  }

  try {
    //await LoadInitialDataActuator(); // Conecta ao banco de dados
  } catch (e) {
    print("Erro ao carregar dados sensores: $e");
  }



  // Inicia a tarefa em background para buscar dados da API e inserir no banco de dados a cada 5 segundos
  Timer.periodic(Duration(seconds: 30), (timer) async {
    await fetchAndStoreSensorData();
    await fetchAndStoreActuatorData();
  });

  // Verifica se o usuário está autenticado
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? password = prefs.getString('password');

    final initialRoute = (username != null && password != null) ? '/home' : '/login';
    runApp(MyApp(initialRoute: initialRoute));
  } catch (e) {
    print("Erro ao obter SharedPreferences: $e");
    runApp(MyApp(initialRoute: '/login'));
  }
}

Future<void> LoadInitialDataActuator() async {
  final Firebaseapi _firebaseapi = Firebaseapi();

  try {
    // Obtém a lista de informações dos atuadores da API Firebase
    final actuatorInfoList = await _firebaseapi.fetchActuatorInfo();
    print('Fetched ${actuatorInfoList.length} actuators info.');

    // Supondo que getAllActuatorDataAPI agora retorna Map<String, List<Actuator>>
    final actuatorDataMap = await _firebaseapi.getAllActuatorDataAPI(actuatorInfoList);
    print('Fetched data for ${actuatorDataMap.keys.length} actuators.');

    // Itera sobre cada actuatorInfo para processar a lista de registros de atuador
    for (var info in actuatorInfoList) {
      List<Actuator> actuatorList = actuatorDataMap[info.id] ?? [];

      for (var actuatorData in actuatorList) {
        var actuatorOut = Actuator(
          id: info.id,
          timestamp: actuatorData.timestamp,
          description: info.description,
          outputPin: actuatorData.outputPin,
          outputPWM: actuatorData.outputPWM,
          unit: actuatorData.unit,
        );

        await Db.insertActuator(Db.database!, actuatorOut);
        print("Inserted actuator ${info.id}, ${actuatorData.timestamp} into the database.");
      }
    }
  } catch (e) {
    print('Exception caught: $e');
  }
}



Future<void> LoadInitialDataSensor() async {
  final Firebaseapi _firebaseapi = Firebaseapi();

  try {
    final sensorInfoList = await _firebaseapi.fetchSensorInfo();
    print('Fetched ${sensorInfoList.length} sensors info.');

    // Supondo que getAllSensorDataAPI agora retorna Map<String, List<Sensor>>
    final sensorDataMap = await _firebaseapi.getAllSensorDataAPI(sensorInfoList);
    print('Fetched data for ${sensorDataMap.keys.length} sensors.');

    // Itera sobre cada sensorInfo para processar a lista de registros de sensor
    for (var info in sensorInfoList) {
      List<Sensor> sensorList = sensorDataMap[info.id] ?? [];

      for (var sensorData in sensorList) {
        var sensorOut = Sensor(
          id: info.id,
          timestamp: sensorData.timestamp,
          description: info.description,
          outputPin1: info.outputPin1,
          outputPin2: info.outputPin2,
          analogValue: sensorData.analogValue,
          digitalValue: sensorData.digitalValue,
          unit: sensorData.unit,
        );

        await Db.insertSensor(Db.database!, sensorOut);
        print("Inserted sensor ${info.id}, ${sensorData.timestamp} into the database.");
      }
    }
  } catch (e) {
    print('Exception caught: $e');
  }
}




Future<void> fetchAndStoreSensorData() async {
  final Firebaseapi _firebaseapi = Firebaseapi();

  try {
    final sensorInfoList = await _firebaseapi.fetchSensorInfo();
    final sensorDataMap = await _firebaseapi.fetchLastSensorsDataValueMap();

    for (var info in sensorInfoList) {
      final sensorData = sensorDataMap[info.id];

      var sensorOut = sensorData != null
          ? Sensor(
              id: info.id,
              timestamp: sensorData.timestamp,
              description: info.description,
              outputPin1: info.outputPin1,
              outputPin2: info.outputPin2,
              analogValue: sensorData.analogValue,
              digitalValue: sensorData.digitalValue,
              unit: sensorData.unit,
            )
          : Sensor(
              id: info.id,
              description: info.description,
              outputPin1: info.outputPin1,
              outputPin2: info.outputPin2,
            );

      await Db.insertSensor(Db.database!, sensorOut);
      print("Inseriu sensor no bancoO");
    }
  } catch (e) {
    print('Failed to fetch sensor data: $e');
  }
}

Future<void> fetchAndStoreActuatorData() async {
  final Firebaseapi _firebaseapi = Firebaseapi();

  try {
    final actuatorInfoList = await _firebaseapi.fetchActuatorInfo();
    final actuatorDataMap = await _firebaseapi.fetchLastActuatorsDataValueMap();

    for (var info in actuatorInfoList) {
      final actuatorData = actuatorDataMap[info.id];

      var actuatorOut = actuatorData != null
          ? Actuator(
              id: info.id,
              timestamp: actuatorData.timestamp,
              description: info.description,
              outputPin: info.outputPin,
              outputPWM: actuatorData.outputPWM,
              unit: actuatorData.unit,
            )
          : Actuator(
              id: info.id,
              description: info.description,
              outputPin: info.outputPin,
            );

      await Db.insertActuator(Db.database!, actuatorOut);
      print("Inseriu atuador no banco");
    }
  } catch (e) {
    print('Failed to fetch actuator data: $e');
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
