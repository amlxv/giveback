import 'package:flutter/material.dart';
import 'package:giveback/utils/login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LoginLayout(
            emailController: emailController,
            passwordController: passwordController),
      ),
    );
  }
}
