import 'package:flutter/material.dart';

import '../models/product_service.dart';
import '../models/producto.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key, this.favoritos});
  final Set<int>? favoritos;

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late final Set<int> _favoritos = widget.favoritos ?? {};
  final _productos = const ProductService().obtenerProductos();

  Widget _platillo(Producto producto) {
    final guardado = _favoritos.contains(producto.id);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(producto.nombre),
      subtitle: Text('\$${producto.precio}'),
      trailing: IconButton(
        tooltip: '${guardado ? 'Quitar' : 'Guardar'} ${producto.nombre}',
        icon: Icon(
          guardado ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        ),
        color: const Color(0xFF007E55),
        onPressed: () => setState(() {
          if (guardado) {
            _favoritos.remove(producto.id);
          } else {
            _favoritos.add(producto.id);
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F6F3),
    appBar: AppBar(title: const Text('Mis favoritos')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Guardados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            if (_favoritos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Toca el corazón de un platillo para guardarlo.'),
              ),
            for (final producto in _productos.where(
              (p) => _favoritos.contains(p.id),
            ))
              _platillo(producto),
            if (_favoritos.length < _productos.length) ...[
              const SizedBox(height: 24),
              const Text(
                'Agregar favoritos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              for (final producto in _productos.where(
                (p) => !_favoritos.contains(p.id),
              ))
                _platillo(producto),
            ],
          ],
        ),
      ),
    ),
  );
}
