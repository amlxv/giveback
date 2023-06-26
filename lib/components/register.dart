import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/main.dart';
import 'package:giveback/pages/auth/login.dart';
import 'package:giveback/utils/misc.dart';
import 'package:giveback/utils/validation.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isLoading = false;

  final TextEditingController nameController =
      TextEditingController(text: 'user');
  final TextEditingController emailController =
      TextEditingController(text: 'user@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'password');
  final TextEditingController confirmPasswordController =
      TextEditingController(text: 'password');

  Future<UserCredential?> createUserWithEmailAndPassword() async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      pushMessage(e.message!);
    }
    return null;
  }

  void handleCreateUser() async {
    if (mounted) setState(() => isLoading = true);

    if (!handleFormValidation()) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    UserCredential? credential = await createUserWithEmailAndPassword();

    if (credential != null) {
      await credential.user!.updateDisplayName(nameController.text);
      if (mounted) setState(() => isLoading = false);
      pushMessage('Welcome, ${nameController.text}!', duration: 3);
      _next();
    }

    if (mounted) setState(() => isLoading = false);
  }

  _next() {
    if (mounted) push(context, const MyApp());
  }

  bool handleFormValidation() {
    if (!validateInput('Name', nameController) ||
        !validateInput('Email', emailController) ||
        !validateInput('Password', passwordController) ||
        !validateInput('Confirm Password', confirmPasswordController)) {
      return false;
    }

    if (!validateConfirmationPassword(
        passwordController, confirmPasswordController)) {
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
        isLoading
            ? const CircularProgressIndicator()
            : SubmitButton(labelText: 'Register', onPressed: handleCreateUser),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () {
                push(context, const Login());
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ],
    );
  }
}
