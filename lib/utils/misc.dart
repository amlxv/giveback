import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String labelText;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.labelText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Text(
        labelText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final bool obscureText;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;

  const InputField({
    super.key,
    this.obscureText = false,
    required this.labelText,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

Future push(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
