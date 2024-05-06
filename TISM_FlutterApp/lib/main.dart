import 'package:flutter/material.dart';
import 'src/screens/login_screen.dart'; // Altere o caminho conforme necessário
import 'src/screens/home_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Certifique-se de que o Flutter foi inicializado

  try {
    final prefs = await SharedPreferences.getInstance(); // Tente obter a instância
    final String? username = prefs.getString('username'); // Tente obter o nome de usuário
    final String? password = prefs.getString('password'); // Tente obter a senha

    // Se um nome de usuário e uma senha estiverem presentes, vá para a tela principal
    final initialRoute = (username != null && password != null) ? '/home' : '/login';

    runApp(MyApp(initialRoute: initialRoute)); // Passa a rota inicial para o app
  } catch (e) {
    // Se algo der errado, print o erro e vá para a tela de login
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
      initialRoute: initialRoute, // Define a rota inicial
      routes: {
        '/login': (context) => const LoginPage(), // Tela de login
        '/home': (context) => HomeScreen(), // Tela principal
      },
    );
  }
}
