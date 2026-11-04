enum Categoria { todos, platillos, bebidas, postres }

extension CategoriaTexto on Categoria {
  String get etiqueta {
    switch (this) {
      case Categoria.todos:
        return 'Todos';
      case Categoria.platillos:
        return 'Platillos';
      case Categoria.bebidas:
        return 'Bebidas';
      case Categoria.postres:
        return 'Postres';
    }
  }
}
