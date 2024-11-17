import 'package:flutter/material.dart';
import 'package:appiot/src/models/sensor.dart'; // Certifique-se de importar o modelo correto
import 'package:appiot/src/models/actuator.dart'; // Certifique-se de importar o modelo correto
import 'package:appiot/src/db/db.dart'; // Importe a classe que contém as funções do banco de dados
import 'package:sqflite/sqflite.dart';
import '../screens/components/bottom_menu.dart';

enum EventType {
  All,
  Sensors,
  Actuators,
}

class Event {
  final String description;
  final String timestamp;

  Event(this.description, this.timestamp);
}

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> events = [];
  EventType selectedEventType = EventType.All; // Tipo de evento selecionado inicialmente

  @override
  void initState() {
    super.initState();
    loadEventsFromDatabase();
  }

  Future<void> loadEventsFromDatabase() async {
    // Conecte ao banco de dados
    Database db = await Db.connect();

    // Carregue sensores e atuadores baseado no tipo de evento selecionado
    List<Sensor> sensors = [];
    List<Actuator> actuators = [];

    switch (selectedEventType) {
      case EventType.All:
        sensors = await Db.getAllSensors(db);
        actuators = await Db.getAllActuators(db);
        break;
      case EventType.Sensors:
        sensors = await Db.getAllSensors(db);
        break;
      case EventType.Actuators:
        actuators = await Db.getAllActuators(db);
        break;
    }

    // Crie eventos baseados nos sensores e atuadores
    List<Event> loadedEvents = [];

    // Exemplo: Criação de eventos com base nos sensores
    for (Sensor sensor in sensors) {
      String description;
      if(sensor.id!.startsWith("ds")){
          description = 'Sensor ${sensor.id} ativado';      
      }
      else{
          description = 'Sensor ${sensor.id}:  Valor: ${sensor.analogValue}${sensor.unit}'; 
      }
      String timestamp = sensor.timestamp.toString(); // Format as needed
      loadedEvents.add(Event(description, timestamp));
    }

    // Exemplo: Criação de eventos com base nos atuadores
    for (Actuator actuator in actuators) {
      String description = 'Atuador ${actuator.id} ativado';
      String timestamp = actuator.timestamp.toString(); // Format as needed
      loadedEvents.add(Event(description, timestamp));
    }

    // Atualize o estado da tela com os eventos carregados
    setState(() {
      events = loadedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico de Eventos',
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
          _buildFilterBar(), // Adiciona a barra de filtro
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index].description),
                  subtitle: Text(events[index].timestamp),
                  leading: Icon(Icons.event),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: Color.fromARGB(255, 127, 222, 130),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton('Todos', EventType.All),
          _buildFilterButton('Sensores', EventType.Sensors),
          _buildFilterButton('Atuadores', EventType.Actuators),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, EventType eventType) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedEventType = eventType;
          loadEventsFromDatabase();
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: selectedEventType == eventType ? Colors.green.shade700 : Colors.black,
          fontWeight: selectedEventType == eventType ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
