import 'package:flutter/material.dart';
import 'actuators_screen';
import 'events_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visão Geral do Processo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Aqui você pode adicionar a imagem centralizada
          Image.asset(
            'processo.png', // Verifique se o caminho da imagem está correto
            width: 400,
            fit: BoxFit.contain,
          ),
          const SizedBox(
              height: 20), // Espaçamento entre a imagem e o container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valores dos Sensores:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Sensor de Nível Tanque 1: 80% (Análogo)'),
                Text('Sensor de Nível Tanque 2: 70% (Digital)'),
                SizedBox(height: 10),
                Text(
                  'Estado das Válvulas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Válvula 1: Aberta'),
                Text('Válvula 2: Fechada'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Implemente a ação para o botão Home
              },
            ),
            IconButton(
              icon: const Icon(Icons.format_list_bulleted),
              onPressed: () {
                // Implemente a ação para o botão Dados
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.data_usage),
              onPressed: () {
                // Implemente a ação para o botão Dados
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActuatorsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.warning),
              onPressed: () {
                // Implemente a ação para o botão Alerta
              },
            ),
          ],
        ),
      ),
    );
  }
}
