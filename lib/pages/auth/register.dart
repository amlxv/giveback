import 'package:flutter/material.dart';
import 'package:giveback/components/register.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -50,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'images/illustrations/register.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Image.asset(
                  'images/illustrations/register.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Center(
                    child: Text(
                      'New\nAccount',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const RegisterForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
