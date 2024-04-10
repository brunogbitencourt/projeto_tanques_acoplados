import 'package:flutter/material.dart';
import 'events_screen.dart';
import 'actuators_screen.dart';
import 'home_screen.dart';

class ActuatorsScreen extends StatefulWidget {
  @override
  _ActuatorsScreenState createState() => _ActuatorsScreenState();
}

class _ActuatorsScreenState extends State<ActuatorsScreen> {
  List<Map<String, dynamic>> actuators = [
    {'name': 'Válvula 01', 'isOpen': false},
    {'name': 'Válvula 02', 'isOpen': false},
    {'name': 'Bomba 01', 'isOpen': false, 'power': 50.0}, // Adicionando a potência como valor padrão para a bomba
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atuadores'),
      ),
      body: ListView.builder(
        itemCount: actuators.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(actuators[index]['name']),
                trailing: Switch(
                  value: actuators[index]['isOpen'],
                  onChanged: (value) {
                    setState(() {
                      actuators[index]['isOpen'] = value;
                    });
                    // Aqui você pode adicionar a lógica para abrir ou fechar o atuador
                  },
                ),
              ),
              if (actuators[index]['name'].startsWith('Bomba'))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Potência:'),
                    Slider(
                      value: actuators[index]['power'] ?? 50.0, // Defina o valor inicial do slider
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          actuators[index]['power'] = value;
                        });
                        // Aqui você pode adicionar a lógica para definir a potência da bomba
                      },
                    ),
                  ],
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false, // Impede a navegação de voltar
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.format_list_bulleted),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => EventsScreen()),
                  (route) => false, // Impede a navegação de voltar
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.data_usage),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ActuatorsScreen()),
                  (route) => false, // Impede a navegação de voltar
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
