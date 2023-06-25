import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:giveback/firebase_options.dart';
import 'package:giveback/pages/auth/login.dart';
import 'package:giveback/utils/menu.dart';
import 'package:giveback/utils/nav_bar.dart';
import 'package:giveback/utils/theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      home: const MyApp(),
      theme: buildTheme(
        Brightness.light,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  bool logged = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() => logged = false);
      } else {
        setState(() => logged = true);
      }
    });
  }

  void updateIndex(int index) {
    setState(() => this.index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !logged
          ? const Login()
          : IndexedStack(index: index, children: screens),
      bottomNavigationBar:
          logged ? NavBar(index: index, updateIndex: updateIndex) : null,
    );
  }
}
