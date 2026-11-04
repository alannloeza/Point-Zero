import 'package:flutter/material.dart';
import '../models/producto.dart';

class PedidoBottomSheet extends StatelessWidget {
  final List<Producto> productos;
  final Map<int, int> cantidades;
  final void Function(Producto producto, int diferencia) onCambiarCantidad;

  const PedidoBottomSheet({
    super.key,
    required this.productos,
    required this.cantidades,
    required this.onCambiarCantidad,
  });

  @override
  Widget build(BuildContext context) {
    final pedidos = productos.where((p) => (cantidades[p.id] ?? 0) > 0).toList();
    final total = pedidos.fold<int>(
      0,
      (acumulado, p) => acumulado + p.precio * (cantidades[p.id] ?? 0),
    );
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFDCE2DD),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tu pedido',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 16),
            if (pedidos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Text('Todavía no has agregado productos.'),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.48,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: pedidos.length,
                  separatorBuilder: (_, _) => const Divider(height: 20),
                  itemBuilder: (context, index) {
                    final producto = pedidos[index];
                    final cantidad = cantidades[producto.id] ?? 0;
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(producto.nombre,
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text('\$${producto.precio} c/u',
                                  style: const TextStyle(color: Color(0xFF647168))),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Quitar uno',
                          onPressed: () => onCambiarCantidad(producto, -1),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('$cantidad',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                        IconButton(
                          tooltip: 'Agregar uno',
                          onPressed: () => onCambiarCantidad(producto, 1),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                Text('\$$total',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: pedidos.isEmpty
                    ? null
                    : () {
                        final messenger = ScaffoldMessenger.of(context);
                        Navigator.of(context).pop();
                        messenger.showSnackBar(
                          const SnackBar(content: Text(
                            'Pedido de demostración. Falta conectar el backend para enviarlo.',
                          )),
                        );
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF255844),
                ),
                child: const Text('Confirmar pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
