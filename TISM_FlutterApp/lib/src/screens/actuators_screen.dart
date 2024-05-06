import 'package:flutter/material.dart';
import '../screens/components/bottom_menu.dart';

class ActuatorsScreen extends StatefulWidget {
  const ActuatorsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        title: const Text('Atuadores'),
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
                    const Text('Potência:'),
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
      bottomNavigationBar: BottomMenu(),
    );
  }
}
