import 'package:appiot/src/db/db.dart';
import 'package:flutter/material.dart';
import 'src/screens/login_screen.dart'; // Altere o caminho conforme necessário
import 'src/screens/home_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Certifique-se de que o Flutter foi inicializado

  try{
      Db.database = await Db.connect(); // Tente conectar ao banco de dados
  }
  catch(e){
    print("Erro ao conectar ao banco de dados: $e");
  }

  try {
    final prefs = await SharedPreferences.getInstance(); 
    final String? username = prefs.getString('username'); 
    final String? password = prefs.getString('password'); 


    final initialRoute = (username != null && password != null) ? '/home' : '/login';

    runApp(MyApp(initialRoute: initialRoute)); 
  } catch (e) {

    print("Erro ao obter SharedPreferences: $e");
    runApp(MyApp(initialRoute: '/login'));
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute, 
      routes: {
        '/login': (context) => const LoginPage(), 
        '/home': (context) => HomeScreen(), 
      },
    );
  }
}
