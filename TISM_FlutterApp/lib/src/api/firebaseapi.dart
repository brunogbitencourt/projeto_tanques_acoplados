import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appiot/src/models/actuator.dart';
import 'package:appiot/src/models/sensor_data.dart';
import 'package:appiot/src/models/sensor_info.dart';
import 'package:appiot/src/models/sensor.dart';

import '../models/actuator_data.dart';
import '../models/actuator_info.dart';

class Firebaseapi {
  Future<List<SensorInfo>> fetchSensorInfo() async {
    try {
      final response = await http.get(Uri.parse('https://tismfirebase.azurewebsites.net/api/Sensor'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<SensorInfo> sensorInfoList = jsonResponse.map((json) => SensorInfo.fromJson(json)).toList();
        return Future.value(sensorInfoList); // Envolve a lista em um futuro
      } else {
        throw Exception('Failed to fetch sensor info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch sensor info: $e');
    }
  }

Future<Map<String, List<Sensor>>> getAllSensorDataAPI(List<SensorInfo> sensorInfoList) async {
  Map<String, List<Sensor>> sensorDataMap = {}; // Mapa para armazenar os dados dos sensores como listas

  for (var sensorInfo in sensorInfoList) {
    if (sensorInfo.id == null) {
      continue; // Pula para a próxima iteração do loop se o ID for nulo
    }
    try {
      final response = await http.get(
          Uri.parse('https://tismfirebase.azurewebsites.net/api/SensorData?id=${sensorInfo.id}'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Lista para armazenar objetos Sensor temporariamente
        List<Sensor> sensors = [];

        // Convertendo a lista de JSON para uma lista de objetos Sensor
        jsonResponse.forEach((sensorJson) {
          Sensor sensor = Sensor.fromJson({...sensorJson, 'id': sensorInfo.id});
          sensors.add(sensor);
        });

        // Adicionando a lista de sensores ao mapa usando o ID do sensorInfo como chave
        sensorDataMap[sensorInfo.id!] = sensors;  // Força sensorInfo.id a ser tratado como String

      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  return sensorDataMap; // Retorna o mapa completo após o loop
}

Future<Map<String, List<Actuator>>> getAllActuatorDataAPI(List<ActuatorInfo> actuatorInfoList) async {
  Map<String, List<Actuator>> actuatorDataMap = {}; // Mapa para armazenar os dados dos sensores como listas

  for (var actuatorInfo in actuatorInfoList) {
    if (actuatorInfo.id == null) {
      continue; // Pula para a próxima iteração do loop se o ID for nulo
    }
    try {
      final response = await http.get(
          Uri.parse('https://tismfirebase.azurewebsites.net/api/ActuatorData?id=${actuatorInfo.id}'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Lista para armazenar objetos Sensor temporariamente
        List<Actuator> actuators = [];

        // Convertendo a lista de JSON para uma lista de objetos Sensor
        jsonResponse.forEach((actuatorJson) {
          Actuator actuator = Actuator.fromJson({...actuatorJson, 'id': actuatorInfo.id});
          actuators.add(actuator);
        });

        // Adicionando a lista de sensores ao mapa usando o ID do sensorInfo como chave
        actuatorDataMap[actuatorInfo.id!] = actuators;  // Força sensorInfo.id a ser tratado como String

      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  return actuatorDataMap; // Retorna o mapa completo após o loop
}



  Future<Map<String, Sensor>> fetchLastSensorsDataValueMap() async {
    try {
      final response = await http.get(Uri.parse(
          'https://tismfirebase.azurewebsites.net/api/SensorData/lastValues'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return jsonResponse.map((key, value) =>
            MapEntry(key, Sensor.fromJson({...value, 'id': key})));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Map<String, Actuator >> fetchLastActuatorsDataValueMap() async {
    try {
      final response = await http.get(Uri.parse('https://tismfirebase.azurewebsites.net/api/ActuatorData/lastValues'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return jsonResponse.map((key, value) =>
            MapEntry(key, Actuator.fromJson({...value, 'id': key})));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<List<ActuatorInfo>> fetchActuatorInfo() async {
    try {
      final response = await http.get(Uri.parse('https://tismfirebase.azurewebsites.net/api/Actuator'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<ActuatorInfo> actuatorInfoList = jsonResponse.map((json) => ActuatorInfo.fromJson(json)).toList();
        return Future.value(actuatorInfoList);
      } else {
        throw Exception('Failed to fetch actuator info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch actuator info: $e');
    }
  }
}
