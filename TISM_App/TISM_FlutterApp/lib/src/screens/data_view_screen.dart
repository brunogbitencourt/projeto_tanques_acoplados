import 'package:flutter/material.dart';
import 'package:appiot/src/models/sensor.dart';

import 'components/bottom_menu.dart'; // Ajuste o caminho conforme necessário

class DataViewScreen extends StatefulWidget {
  const DataViewScreen({Key? key}) : super(key: key);

  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  Sensor? selectedSensor;
  List<Sensor> sensors = []; // Lista para armazenar os sensores

  @override
  void initState() {
    super.initState();
    loadSensors();
  }

  void loadSensors() async {
    // Aqui você carregaria sua lista de sensores, por exemplo, de um banco de dados ou API
    // Esta é uma lista mocada para exemplo
    sensors = [
      Sensor(id: 'Sensor1', description: 'Sensor de Temperatura'),
      Sensor(id: 'Sensor2', description: 'Sensor de Umidade'),
      // Adicione mais sensores conforme necessário
    ];
    // Após carregar os sensores, você pode definir um sensor padrão para ser selecionado
    if (sensors.isNotEmpty) {
      setState(() {
        selectedSensor = sensors[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data View'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Sensor>(
              value: selectedSensor,
              onChanged: (Sensor? newValue) {
                setState(() {
                  selectedSensor = newValue;
                });
                // Você pode querer carregar os dados do gráfico aqui
              },
              items: sensors.map<DropdownMenuItem<Sensor>>((Sensor sensor) {
                return DropdownMenuItem<Sensor>(
                  value: sensor,
                  child: Text(sensor.description ?? 'Descrição não disponível'),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              // Este container irá conter o gráfico
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Gráfico do Sensor',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
