import 'categoria.dart';

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final int precio;
  final Categoria categoria;
  final bool disponible;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    this.disponible = true,
  });
}
