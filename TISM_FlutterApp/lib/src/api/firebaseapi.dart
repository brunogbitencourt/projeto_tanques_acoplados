import 'dart:convert';
import 'package:appiot/src/models/sensor_data.dart';
import 'package:appiot/src/models/sensor_info.dart';
import 'package:appiot/src/screens/components/sensor_details.dart';
import 'package:http/http.dart' as http;
import 'package:appiot/src/models/sensor.dart';

class Firebaseapi {

  Future<List<SensorInfo>> fetchSensorInfo() async {
  try {
    final response = await http.get(
        Uri.parse('https://tismfirebase.azurewebsites.net/api/Sensor'));

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




  

  Future<Map<String, Sensor>> fetchLastSensorsDataValueMap() async {
  try {
    final response = await http.get(
        Uri.parse('https://tismfirebase.azurewebsites.net/api/SensorData/lastValues'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      return jsonResponse.map((key, value) => MapEntry(
          key, Sensor.fromJson({...value, 'id': key})));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}


}
