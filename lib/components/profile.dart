import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/main.dart';
import 'package:giveback/utils/misc.dart';
import 'package:giveback/utils/validation.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  User? user;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        if (mounted) push(context, const MyApp());
      } else {
        if (mounted) {
          setState(() {
            this.user = user;
            nameController.text = user.displayName ?? '';
            emailController.text = user.email ?? '';
          });
        }
      }
    });

    db.collection('users').doc(auth.currentUser?.uid).get().then(
      (DocumentSnapshot documentSnapshot) {
        final userRef = documentSnapshot.data() as Map<String, dynamic>;
        phoneController.text = userRef['phone'] ?? '';
      },
      onError: (Object? error) => pushMessage(error.toString()),
    );
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> handleUpdate() async {
    if (mounted) setState(() => isLoading = true);

    try {
      if (!validateInput("Name", nameController) ||
          !validateInput("Email", emailController) ||
          !validateInput("Phone", phoneController)) {
        if (mounted) setState(() => isLoading = false);
        return;
      }

      user!.updateDisplayName(nameController.text);
      user!.updateEmail(emailController.text);

      await db.collection('users').doc(user!.uid).set({
        'phone': phoneController.text,
      });

      if (passwordController.text.isNotEmpty) {
        if (!validateInput("Password", passwordController)) {
          if (mounted) setState(() => isLoading = false);
          return;
        }
        user!.updatePassword(passwordController.text);
        handleLogout();
      }
    } on FirebaseException catch (e) {
      if (mounted) setState(() => isLoading = false);

      pushMessage(e.message ?? 'An error occurred');
    }

    if (mounted) setState(() => isLoading = false);
    pushMessage("Profile updated");
  }

  void handleLogout() {
    auth.signOut();
    pushMessage("You have been logged out");
    if (mounted) push(context, const MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          labelText: 'Name',
          controller: nameController,
          icon: Icons.person,
        ),
        const SizedBox(
          height: 20,
        ),
        InputField(
          labelText: 'Email',
          controller: emailController,
          icon: Icons.email_rounded,
        ),
        const SizedBox(
          height: 20,
        ),
        InputField(
          labelText: 'Phone Number',
          controller: phoneController,
          icon: Icons.phone,
        ),
        const SizedBox(
          height: 20,
        ),
        InputField(
          obscureText: true,
          labelText: 'Password',
          controller: passwordController,
          icon: Icons.lock,
        ),
        const SizedBox(
          height: 20,
        ),
        isLoading
            ? const CircularProgressIndicator()
            : SubmitButton(labelText: "Update", onPressed: handleUpdate),
        const SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: handleLogout,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black54,
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
