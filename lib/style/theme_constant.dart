// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const Color PRIMARY_COLOR = Color(0xFF438440);
const Color RADIO_COLOR_DARK = Color.fromARGB(255, 163, 199, 250);
const Color RADIO_COLOR_LIGHT = Color(0xFF3273f6);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  secondaryHeaderColor: PRIMARY_COLOR,
  textTheme: const TextTheme(
    button: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
    overline: TextStyle(
        color: PRIMARY_COLOR,
        fontFamily: 'Montserrat'), // text button secondary
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      return RADIO_COLOR_LIGHT;
    }),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.cyan,
  textTheme: const TextTheme(
    button: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
    headline1: TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      return Colors.black;
    }),
  ),
);
