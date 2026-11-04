import 'package:flutter/material.dart';
import 'package:point_zero/screens/splash_screen.dart'; // <-- Verifica que esté importado

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Comandas',
      debugShowCheckedModeBanner: false,
      // Aquí es donde obligas a la app a iniciar en el Splash
      home: const SplashScreen(), 
    );
  }
}