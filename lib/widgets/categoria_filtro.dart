import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoriaFiltro extends StatelessWidget {
  final Categoria seleccionada;
  final ValueChanged<Categoria> onSeleccionar;

  const CategoriaFiltro({
    super.key,
    required this.seleccionada,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Categoria.values.map((categoria) {
          final activa = seleccionada == categoria;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onSeleccionar(categoria),
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: activa ? const Color(0xFF255844) : const Color(0xFFF5F6F4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: activa ? const Color(0xFF255844) : const Color(0xFFE2E5E0),
                  ),
                ),
                child: Text(
                  categoria.etiqueta,
                  style: TextStyle(
                    color: activa ? Colors.white : const Color(0xFF5B655E),
                    fontSize: 11,
                    fontWeight: activa ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
