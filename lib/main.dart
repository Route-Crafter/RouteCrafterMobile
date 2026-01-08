// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:routes_mobile/screens/routes/routes_screen.dart';
import 'package:routes_mobile/screens/theme/theme.dart';
import 'package:routes_mobile/screens/theme/util.dart';
import './globals/injection_container.dart' as ic;

void main() {
  ic.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Inter", "Montserrat");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: RoutesScreen()
    );
  }
}