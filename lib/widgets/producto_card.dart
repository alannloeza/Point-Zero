import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/categoria.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onAgregar;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDEE3DD)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFECF2EE),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              producto.categoria.etiqueta,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF275C45),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            producto.nombre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Color(0xFF101510),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            producto.descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              height: 1.4,
              color: Color(0xFF59675E),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                '\$${producto.precio}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF141B16),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 2,
                child: producto.disponible
                    ? SizedBox(
                        height: 29,
                        child: FilledButton(
                          onPressed: onAgregar,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF255844),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('+ Agregar', maxLines: 1),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: 29,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F5F3),
                          border: Border.all(color: const Color(0xFFD9DFD9)),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Text(
                          'Agotado',
                          style: TextStyle(fontSize: 10, color: Color(0xFF6A766D)),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
