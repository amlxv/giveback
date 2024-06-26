import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/main.dart';
import 'package:giveback/pages/auth/register.dart';
import 'package:giveback/utils/misc.dart';
import 'package:giveback/utils/validation.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<UserCredential?> signInWithEmailAndPassword() async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      pushMessage(e.message!);
    }
    return null;
  }

  void handleSignIn() async {
    if (mounted) setState(() => isLoading = true);

    if (!handleFormValidation()) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    UserCredential? userCredential = await signInWithEmailAndPassword();

    if (userCredential != null) {
      if (mounted) setState(() => isLoading = false);
      pushMessage('Welcome, ${userCredential.user!.displayName}!', duration: 3);
    }

    _next();
  }

  _next() {
    if (mounted) push(context, const MyApp());
  }

  bool handleFormValidation() {
    if (!validateInput('Email', emailController) ||
        !validateInput('Password', passwordController)) {
      return false;
    }

    return true;
  }

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
        isLoading
            ? const CircularProgressIndicator()
            : SubmitButton(
                labelText: 'Login',
                onPressed: handleSignIn,
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
