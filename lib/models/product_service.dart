import 'categoria.dart';
import 'producto.dart';

/// Datos locales de ejemplo. Sustituye esta lista por los datos de tu API.
class ProductService {
  const ProductService();

  List<Producto> obtenerProductos() {
    return const [
      Producto(
        id: 1,
        nombre: 'Enchiladas verdes',
        descripcion: 'Pollo, salsa verde, crema y queso fresco.',
        precio: 110,
        categoria: Categoria.platillos,
      ),
      Producto(
        id: 2,
        nombre: 'Tacos de pollo',
        descripcion: 'Tres tacos con guarnición de la casa.',
        precio: 85,
        categoria: Categoria.platillos,
      ),
      Producto(
        id: 3,
        nombre: 'Agua de jamaica',
        descripcion: 'Agua fresca. Vaso de 500 ml.',
        precio: 35,
        categoria: Categoria.bebidas,
      ),
      Producto(
        id: 4,
        nombre: 'Flan de la casa',
        descripcion: 'Flan de vainilla con caramelo.',
        precio: 55,
        categoria: Categoria.postres,
        disponible: false,
      ),
    ];
  }
}
