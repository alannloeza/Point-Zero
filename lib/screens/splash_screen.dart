import 'package:flutter/material.dart';

/// Pantalla splash opcional; no se usa para entrar al home por defecto.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF255844),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, color: Colors.white, size: 68),
            SizedBox(height: 16),
            Text('Mi Restaurante',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                )),
          ],
        ),
      ),
    );
  }
}
