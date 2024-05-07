import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../events_screen.dart';
import '../actuators_screen.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key}) : super(key: key);

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });

        

        // Coloque o código de navegação aqui, conforme necessário
        switch (_selectedIndex) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
            break;
          case 1:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EventsScreen()),
              (route) => false,
            );
            break;
          case 2:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ActuatorsScreen()),
              (route) => false,
            );
            break;
          case 3:
            // Faça algo quando o item "Configurations" for selecionado
            break;
          case 4:
            // Faça algo quando o item "About Us" for selecionado
            break;
          
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.data_usage),
          label: 'Actuators',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About Us',
        ),
      ],
    );
  }
}
