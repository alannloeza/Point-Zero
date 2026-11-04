import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../models/product_service.dart';
import '../models/producto.dart';
import '../widgets/categoria_filtro.dart';
import '../widgets/pedido_bottom_sheet.dart';
import '../widgets/producto_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.carrito});

  final Map<int, int>? carrito;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _busquedaController = TextEditingController();
  final List<Producto> _productos = const ProductService().obtenerProductos();
  Categoria _categoria = Categoria.todos;
  String _busqueda = '';

  // Carrito de demostración: 2 enchiladas = $220, como en la referencia.
  // Cambia a {} si quieres empezar con el carrito vacío.
  late final Map<int, int> _carrito = widget.carrito ?? {1: 2};

  List<Producto> get _productosVisibles => _productos.where((producto) {
        final coincideCategoria = _categoria == Categoria.todos ||
            producto.categoria == _categoria;
        final texto = _busqueda.trim().toLowerCase();
        final coincideTexto = producto.nombre.toLowerCase().contains(texto) ||
            producto.descripcion.toLowerCase().contains(texto);
        return coincideCategoria && coincideTexto;
      }).toList();

  int get _cantidad =>
      _carrito.values.fold<int>(0, (total, cantidad) => total + cantidad);

  int get _total => _productos.fold<int>(
        0,
        (total, producto) =>
            total + producto.precio * (_carrito[producto.id] ?? 0),
      );

  void _cambiarCantidad(Producto producto, int diferencia) {
    if (!producto.disponible && diferencia > 0) return;
    setState(() {
      final nuevaCantidad = (_carrito[producto.id] ?? 0) + diferencia;
      if (nuevaCantidad <= 0) {
        _carrito.remove(producto.id);
      } else {
        _carrito[producto.id] = nuevaCantidad;
      }
    });
  }

  void _abrirPedido() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, actualizarHoja) => PedidoBottomSheet(
          productos: _productos,
          cantidades: _carrito,
          onCambiarCantidad: (producto, diferencia) {
            _cambiarCantidad(producto, diferencia);
            actualizarHoja(() {});
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _productosVisibles;

    return Scaffold(
      backgroundColor: const Color(0xFFE5E7E5),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                children: [
                  _construirEncabezado(),
                  Expanded(
                    child: Container(
                      color: const Color(0xFFF5F6F3),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 16, 18, 11),
                                child: Text(
                                  '${visibles.length} PRODUCTOS',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF68736D),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: visibles.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No se encontraron productos.',
                                          style: TextStyle(color: Color(0xFF647168)),
                                        ),
                                      )
                                    : LayoutBuilder(
                                        builder: (context, constraints) {
                                          final columnas =
                                              constraints.maxWidth > 450 ? 3 : 2;
                                          return GridView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              14, 0, 14, _cantidad > 0 ? 105 : 20,
                                            ),
                                            keyboardDismissBehavior:
                                                ScrollViewKeyboardDismissBehavior.onDrag,
                                            itemCount: visibles.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: columnas,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 10,
                                              mainAxisExtent: 144,
                                            ),
                                            itemBuilder: (context, index) {
                                              final producto = visibles[index];
                                              return ProductoCard(
                                                producto: producto,
                                                onAgregar: () =>
                                                    _cambiarCantidad(producto, 1),
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                          if (_cantidad > 0)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 22,
                              child: Center(
                                child: Material(
                                  color: const Color(0xFF255844),
                                  elevation: 10,
                                  shadowColor: const Color(0x55255844),
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: _abrirPedido,
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(minWidth: 168),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 15,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 11,
                                            backgroundColor:
                                                const Color(0xFF4A816D),
                                            child: Text(
                                              '$_cantidad',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 9),
                                          const Text(
                                            'Ver\npedido',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              height: 1.13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 21),
                                          Text(
                                            '\$$_total',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirEncabezado() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFECF2EE),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.table_restaurant_outlined,
                        size: 14, color: Color(0xFF255844)),
                    SizedBox(width: 6),
                    Text('Mesa 03',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF255844),
                        )),
                  ],
                ),
              ),
              IconButton.outlined(
                onPressed: _abrirPedido,
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                tooltip: 'Ver pedido',
                style: IconButton.styleFrom(
                  foregroundColor: const Color(0xFF5C6A60),
                  side: const BorderSide(color: Color(0xFFDFE4DE)),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Menú',
            style: TextStyle(
              color: Color(0xFF111811),
              fontWeight: FontWeight.w800,
              fontSize: 26,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Elige lo que quieras pedir',
              style: TextStyle(fontSize: 11, color: Color(0xFF5E6B61))),
          const SizedBox(height: 13),
          SizedBox(
            height: 38,
            child: TextField(
              controller: _busquedaController,
              onChanged: (valor) => setState(() => _busqueda = valor),
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar platillo o bebida',
                hintStyle:
                    const TextStyle(color: Color(0xFF929B94), fontSize: 12),
                prefixIcon: const Icon(Icons.search,
                    color: Color(0xFF929B94), size: 19),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 33, minHeight: 38),
                filled: true,
                fillColor: const Color(0xFF171B18),
                contentPadding: const EdgeInsets.symmetric(vertical: 9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CategoriaFiltro(
            seleccionada: _categoria,
            onSeleccionar: (categoria) => setState(() => _categoria = categoria),
          ),
        ],
      ),
    );
  }
}
