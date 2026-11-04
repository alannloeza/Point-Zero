import 'package:flutter/material.dart';

import '../models/product_service.dart';
import '../widgets/pedido_bottom_sheet.dart';
import 'home_screen.dart';
import 'perfil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indiceActual = 0;
  final Map<int, int> _carrito = {1: 2};

  void _verPedido() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, actualizarHoja) => PedidoBottomSheet(
          productos: const ProductService().obtenerProductos(),
          cantidades: _carrito,
          onCambiarCantidad: (producto, diferencia) {
            if (!producto.disponible && diferencia > 0) return;
            setState(() {
              final cantidad = (_carrito[producto.id] ?? 0) + diferencia;
              if (cantidad <= 0) {
                _carrito.remove(producto.id);
              } else {
                _carrito[producto.id] = cantidad;
              }
            });
            actualizarHoja(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _indiceActual,
      children: [
        HomeScreen(carrito: _carrito),
        PerfilScreen(
          onVerPedido: _verPedido,
          onVolverAlMenu: () => setState(() => _indiceActual = 0),
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _indiceActual,
      onTap: (indice) => setState(() => _indiceActual = indice),
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF255844),
      unselectedItemColor: const Color(0xFF5E6B61),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menú',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    ),
  );
}
