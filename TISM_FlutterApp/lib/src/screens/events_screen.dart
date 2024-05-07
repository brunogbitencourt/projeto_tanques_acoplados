import 'package:flutter/material.dart';
import '../screens/components/bottom_menu.dart';

class Event {
  final String description;
  final String timestamp;

  Event(this.description, this.timestamp);
}

// ignore: use_key_in_widget_constructors
class EventsScreen extends StatelessWidget {
  final List<Event> events = [
    Event('Sensor de temperatura atingiu 40°C', '2024-04-07 09:30'),
    Event('Válvula 01 aberta', '2024-04-07 10:15'),
    Event('Bomba 01 ligada com 70% de potência', '2024-04-07 11:00'),
    Event('Sensor de nível tanque 02 ativado', '2024-04-07 11:45'),
    Event('Alerta de pressão alta', '2024-04-07 12:30'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Eventos'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index].description),
            subtitle: Text(events[index].timestamp),
            leading: const Icon(Icons.event),
          );
        },
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
