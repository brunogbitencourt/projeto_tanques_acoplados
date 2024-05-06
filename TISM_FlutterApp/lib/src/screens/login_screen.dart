import 'package:flutter/material.dart';
import 'components/login_form.dart'; // Importe o formulário de login

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: LoginForm(), // Mostra o formulário de login
      ),
    );
  }
}
