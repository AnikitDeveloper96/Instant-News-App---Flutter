import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes.dart';
import 'screens/home/main_screen.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: AppRoutes().routes,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
