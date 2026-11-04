import 'package:flutter/material.dart';

import 'direcciones_screen.dart';
import 'editar_perfil_screen.dart';
import 'favoritos_screen.dart';
import 'metodos_pago_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({
    super.key,
    required this.onVerPedido,
    required this.onVolverAlMenu,
  });

  final VoidCallback onVerPedido;
  final VoidCallback onVolverAlMenu;

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String _nombre = '';
  String _correo = '';
  String _telefono = '';
  String _direccion = '';
  String _metodoPago = 'Efectivo';
  final Set<int> _favoritos = {};

  Future<void> _editar() async {
    final datos =
        await Navigator.push<({String nombre, String correo, String telefono})>(
          context,
          MaterialPageRoute(
            builder: (_) => EditarPerfilScreen(
              nombre: _nombre,
              correo: _correo,
              telefono: _telefono,
            ),
          ),
        );
    if (!mounted || datos == null) return;
    setState(() {
      _nombre = datos.nombre;
      _correo = datos.correo;
      _telefono = datos.telefono;
    });
    _avisar('Tus datos se actualizaron.');
  }

  Future<void> _editarDireccion() async {
    final direccion = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => DireccionesScreen(direccion: _direccion),
      ),
    );
    if (!mounted || direccion == null) return;
    setState(() => _direccion = direccion);
    _avisar(direccion.isEmpty ? 'Dirección eliminada.' : 'Dirección guardada.');
  }

  Future<void> _elegirPago() async {
    final metodo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => MetodosPagoScreen(metodo: _metodoPago)),
    );
    if (!mounted || metodo == null) return;
    setState(() => _metodoPago = metodo);
    _avisar('Preferencia de pago guardada.');
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _abrirAyuda() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda y soporte'),
        content: const SingleChildScrollView(
          child: Text(
            '• Toca el engrane para editar tus datos.\n\n'
            '• En Mis pedidos puedes revisar y ajustar tu pedido actual.\n\n'
            '• En Mis favoritos puedes guardar los platillos que te gustan.\n\n'
            'Si necesitas ayuda con el servicio, acércate al personal del restaurante.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iniciales = _nombre
        .split(' ')
        .where((parte) => parte.isNotEmpty)
        .take(2)
        .map((parte) => parte.characters.first)
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFE5E7E5),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ColoredBox(
              color: const Color(0xFFF5F6F3),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 44),
                    color: const Color(0xFF0B5D46),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'POINT ZERO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 34,
                              backgroundColor: const Color(0xFFDCEBB4),
                              foregroundColor: const Color(0xFF164B32),
                              child: iniciales.isEmpty
                                  ? const Icon(
                                      Icons.person_outline_rounded,
                                      size: 34,
                                    )
                                  : Text(
                                      iniciales,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                            const Spacer(),
                            IconButton.outlined(
                              onPressed: _editar,
                              tooltip: 'Editar datos',
                              icon: const Icon(
                                Icons.settings_outlined,
                                size: 23,
                              ),
                              style: IconButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF236D58),
                                side: const BorderSide(
                                  color: Color(0xFF478574),
                                ),
                                minimumSize: const Size(48, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _nombre.isEmpty ? 'Tu perfil' : _nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _correo.isEmpty ? 'Mi cuenta' : _correo,
                          style: const TextStyle(
                            color: Color(0xFFE1F2E9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -26),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Material(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Color(0xFFE5E9E3),
                            width: 0.75,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            _opcion(
                              Icons.receipt_long_outlined,
                              'Mis pedidos',
                              widget.onVerPedido,
                            ),
                            _opcion(
                              Icons.favorite_border_rounded,
                              'Mis favoritos',
                              () => Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FavoritosScreen(favoritos: _favoritos),
                                ),
                              ),
                            ),
                            _opcion(
                              Icons.location_on_outlined,
                              'Direcciones guardadas',
                              _editarDireccion,
                            ),
                            _opcion(
                              Icons.credit_card_outlined,
                              'Métodos de pago',
                              _elegirPago,
                            ),
                            _opcion(
                              Icons.help_outline_rounded,
                              'Ayuda y soporte',
                              _abrirAyuda,
                            ),
                            _opcion(
                              Icons.logout_rounded,
                              'Salir al menú',
                              widget.onVolverAlMenu,
                              ultima: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Text(
                      'Tus datos se conservan mientras usas la aplicación.',
                      style: TextStyle(
                        color: Color(0xFF647168),
                        fontSize: 12,
                        height: 1.5,
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

  Widget _opcion(
    IconData icono,
    String titulo,
    VoidCallback onTap, {
    bool ultima = false,
  }) => Column(
    children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        minTileHeight: 72,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5EF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, color: const Color(0xFF4E6A50), size: 21),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF23352B),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 19,
          color: Color(0xFF9AA69A),
        ),
        onTap: onTap,
      ),
      if (!ultima)
        const Divider(
          height: 1,
          indent: 18,
          endIndent: 18,
          color: Color(0xFFF0F1EC),
        ),
    ],
  );
}
