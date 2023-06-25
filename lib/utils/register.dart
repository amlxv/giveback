import 'package:flutter/material.dart';
import 'package:giveback/pages/auth/register.dart';
import 'package:giveback/utils/misc.dart';

class RegisterLayout extends StatelessWidget {
  const RegisterLayout({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -100,
              right: 0,
              bottom: 0,
              left: 0,
              child: Image.asset(
                'images/illustration.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Image.asset(
              'images/illustration.png',
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
            child: RegisterForm(
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(
            labelText: 'Name',
            icon: Icons.person_2_rounded,
            controller: nameController),
        const SizedBox(height: 20),
        InputField(
            labelText: 'Email',
            icon: Icons.email_rounded,
            controller: emailController),
        const SizedBox(height: 20),
        InputField(
            labelText: 'Password',
            icon: Icons.key_rounded,
            controller: passwordController,
            obscureText: true),
        const SizedBox(height: 20),
        InputField(
            labelText: 'Confirm Password',
            icon: Icons.key_rounded,
            controller: confirmPasswordController,
            obscureText: true),
        const SizedBox(height: 30),
        SubmitButton(
            labelText: 'Register',
            onPressed: () {
              print('Login button pressed');
            }),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () {
                push(context, const Register());
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ],
    );
  }
}
