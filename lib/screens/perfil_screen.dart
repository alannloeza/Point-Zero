import 'package:flutter/material.dart';

/// Pantalla base para implementar el perfil más adelante.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 52, color: Color(0xFF255844)),
            SizedBox(height: 12),
            Text('Configura aquí los datos de tu perfil.'),
          ],
        ),
      ),
    );
  }
}
