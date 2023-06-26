import 'package:flutter/material.dart';
import 'package:giveback/components/login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'images/undraw/welcoming.png',
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 35),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const LoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
