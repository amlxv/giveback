import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giveback/main.dart';
import 'package:giveback/utils/misc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;

  @override
  void initState() {
    super.initState();
    handleAuth();
  }

  handleAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (mounted) push(context, const MyApp());
      } else {
        if (mounted) setState(() => this.user = user);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    handleAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Welcome, ${user?.displayName}"),
          Text("Your email is ${user?.email}"),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                push(context, const MyApp());
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
