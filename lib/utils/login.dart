import 'package:flutter/material.dart';
import 'package:giveback/pages/auth/register.dart';
import 'package:giveback/utils/misc.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        Image.asset(
          'images/undraw_welcoming.png',
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
            child: LoginForm(
              emailController: emailController,
              passwordController: passwordController,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(
          labelText: 'Email',
          icon: Icons.email_rounded,
          controller: emailController,
        ),
        const SizedBox(height: 20),
        InputField(
          labelText: 'Password',
          icon: Icons.password_rounded,
          obscureText: true,
          controller: passwordController,
        ),
        const SizedBox(height: 30),
        SubmitButton(
          labelText: 'Login',
          onPressed: () {
            print('Submit button pressed /* Login');
          },
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have an account?'),
            TextButton(
              onPressed: () {
                push(context, const Register());
              },
              child: const Text('Create now!'),
            ),
          ],
        ),
      ],
    );
  }
}
