import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:giveback/firebase_options.dart';
import 'package:giveback/pages/auth/login.dart';
import 'package:giveback/utils/menu.dart';
import 'package:giveback/utils/navbar.dart';
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
  final int? currentIndex;
  const MyApp({super.key, this.currentIndex});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  bool logged = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentIndex != null) {
      setState(() => index = widget.currentIndex!);
    }
    handleAuth();
  }

  void updateIndex(int index) {
    setState(() => this.index = index);
  }

  void handleAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() => logged = false);
      } else {
        setState(() => logged = true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    handleAuth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !logged
          ? const Login()
          : IndexedStack(
              index: index, children: getScreens(updateIndex) as List<Widget>),
      bottomNavigationBar:
          logged ? NavBar(index: index, updateIndex: updateIndex) : null,
    );
  }
}
