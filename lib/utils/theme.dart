import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(brightness) {
  // set the background color to white

  var baseTheme = ThemeData(
    brightness: brightness,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
  );
}
