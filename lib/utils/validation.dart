import 'package:flutter/material.dart';
import 'package:giveback/utils/misc.dart';

bool validateInput(String label, TextEditingController input) {
  if (input.text.isEmpty) {
    pushMessage('$label is required');
    return false;
  }

  if (label.toLowerCase() == 'email') {
    return validateEmail(input.text);
  }

  if (label.toLowerCase() == 'password') {
    return validatePassword(input.text);
  }

  return true;
}

bool validateEmail(String email) {
  if (!email.contains('@')) {
    pushMessage('Invalid email');
    return false;
  }
  return true;
}

bool validatePassword(String password) {
  if (password.length < 6) {
    pushMessage('Password must be at least 6 characters');
    return false;
  }
  return true;
}

bool validateConfirmationPassword(
    TextEditingController password, TextEditingController confirmPassword) {
  if (password.text != confirmPassword.text) {
    pushMessage('Passwords do not match');
    return false;
  }
  return true;
}
