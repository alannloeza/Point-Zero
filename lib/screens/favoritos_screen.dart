import 'package:flutter/material.dart';

/// Pantalla base para implementar los favoritos más adelante.
class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 52, color: Color(0xFF255844)),
            SizedBox(height: 12),
            Text('Aquí aparecerán tus platillos favoritos.'),
          ],
        ),
      ),
    );
  }
}
