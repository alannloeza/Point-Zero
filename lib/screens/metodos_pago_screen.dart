import 'package:flutter/material.dart';

class MetodosPagoScreen extends StatefulWidget {
  const MetodosPagoScreen({super.key, required this.metodo});
  final String metodo;

  @override
  State<MetodosPagoScreen> createState() => _MetodosPagoScreenState();
}

class _MetodosPagoScreenState extends State<MetodosPagoScreen> {
  late String _seleccionado = widget.metodo;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F6F3),
    appBar: AppBar(title: const Text('Métodos de pago')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Método preferido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text('Elige cómo prefieres pagar al recibir tu pedido.'),
            const SizedBox(height: 20),
            for (final metodo in ['Efectivo', 'Tarjeta al recibir'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  _seleccionado == metodo
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                title: Text(metodo),
                selected: _seleccionado == metodo,
                onTap: () => setState(() => _seleccionado = metodo),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context, _seleccionado),
              child: const Text('Guardar preferencia'),
            ),
          ],
        ),
      ),
    ),
  );
}
