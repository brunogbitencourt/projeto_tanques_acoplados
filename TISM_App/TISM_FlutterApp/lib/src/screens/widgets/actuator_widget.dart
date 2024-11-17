import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../db/db.dart';
import '../../models/actuator.dart';
import '../components/actuator_details.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl

class ActuatorWidget extends StatefulWidget {
  final Actuator actuator;

  const ActuatorWidget({Key? key, required this.actuator}) : super(key: key);

  @override
  _ActuatorWidgetState createState() => _ActuatorWidgetState();
}

class _ActuatorWidgetState extends State<ActuatorWidget> {
  late double sliderValue;
  late String textTitle; // Variável para armazenar o título personalizado

  @override
  void initState() {
    super.initState();
    sliderValue = widget.actuator.outputPWM ?? 0;
    textTitle = _buildTitle(widget.actuator.id);
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      Db.database = await Db.connect();
    } catch (e) {
      print("Erro ao conectar ao banco de dados: $e");
    }
  }

  String _buildTitle(String? id) {
    if (id == null) return '';
    if (id.startsWith("AV")) {
      return "Valve $id";
    } else if (id.startsWith("AM")) {
      return "Motor $id";
    } else if (id.startsWith("AP")) {
      return "Pump $id";
    }
    return id; // Caso padrão, use o ID como está
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.green.shade700, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.green.shade700,
            child: Text(
              textTitle,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ActuatorDetails(actuator: widget.actuator);
                },
              );
            },
            subtitle: _buildControlWidgets(),
          ),
          Divider(
            color: Colors.green.shade700,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "  " + dateFormat.format(widget.actuator.timestamp ?? DateTime.now()),
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Switch(
              value: widget.actuator.outputPWM != 0,
              onChanged: (value) async {
                double newPWM = value ? 100.0 : 0.0;
                setState(() {
                  widget.actuator.outputPWM = newPWM;
                  sliderValue = newPWM;
                });
                await _updateActuatorAndSendData(newPWM);
              },
              activeColor: Colors.green.shade700,
            ),
          ],
        ),
        // Outros widgets ou controles podem ser adicionados aqui
      ],
    );
  }

  Future<void> _updateActuatorAndSendData(double newPWM) async {
    widget.actuator.outputPWM = newPWM;
    await Db.insertActuator(Db.database!, widget.actuator);
    await sendDataToAPI();
    await publishMqttMessage(widget.actuator.id!, newPWM.toInt());
  }

  Future<void> sendDataToAPI() async {
    Map<String, dynamic> actuatorData = {
      'Id': widget.actuator.id ?? 'default_id', // Adiciona um id padrão caso seja null
      'Timestamp': widget.actuator.timestamp?.toIso8601String() ?? '',
      'PwmOutput': widget.actuator.outputPWM ?? 0,
      'State': 0, // Ajuste conforme necessário
      //'Unit': widget.actuator.unit ?? 'V'
    };

    Map<String, dynamic> payload = {
      'actuatorData': actuatorData  // Envolve os dados do atuador no campo esperado pela API
    };

    String jsonString = json.encode(payload);
    String apiUrl = 'https://tismfirebase.azurewebsites.net/api/ActuatorData';

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonString
      );

      if (response.statusCode == 200) {
        print('Dados enviados com sucesso!');
      } else {
        print('Falha ao enviar dados: ${response.statusCode}');
        print('Resposta: ${response.body}');
      }
    } catch (e) {
      print('Erro ao enviar dados: $e');
    }
  }

  Future<void> publishMqttMessage(String id, int pwmValue) async {
    String topic = "actions";
    String message = "$id-$pwmValue";

    var url = Uri.parse('https://tismmqtt.azurewebsites.net/api/Mqtt/publish');
    var body = jsonEncode({
      'topic': topic,
      'message': message
    });

    try {
      var response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print('MQTT message ${message} published successfully');
      } else {
        print('Failed to publish MQTT message: ${response.body}');
      }
    } catch (e) {
      print('Error sending MQTT message: $e');
    }
  }
}
