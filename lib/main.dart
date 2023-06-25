import 'package:flutter/material.dart';
import 'package:giveback/pages/auth/register.dart';
import 'package:giveback/utils/menu.dart';
import 'package:giveback/utils/nav_bar.dart';
import 'package:giveback/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: const MyApp(), theme: buildTheme(Brightness.light)));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  bool logged = false;

  void updateIndex(int index) {
    setState(() => this.index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !logged
          ? const Register()
          : IndexedStack(index: index, children: screens),
      bottomNavigationBar:
          logged ? NavBar(index: index, updateIndex: updateIndex) : null,
    );
  }
}
