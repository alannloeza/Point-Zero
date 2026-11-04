import 'package:flutter/material.dart';

class DireccionesScreen extends StatefulWidget {
  const DireccionesScreen({super.key, required this.direccion});
  final String direccion;

  @override
  State<DireccionesScreen> createState() => _DireccionesScreenState();
}

class _DireccionesScreenState extends State<DireccionesScreen> {
  final _form = GlobalKey<FormState>();
  late final _direccion = TextEditingController(text: widget.direccion);

  @override
  void dispose() {
    _direccion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F6F3),
    appBar: AppBar(title: const Text('Direcciones guardadas')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Dirección principal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text('Agrega calle, número, colonia y ciudad.'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _direccion,
                minLines: 3,
                maxLines: 5,
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                validator: (texto) => (texto ?? '').trim().length < 10
                    ? 'Escribe una dirección más completa.'
                    : null,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    Navigator.pop(context, _direccion.text.trim());
                  }
                },
                child: const Text('Guardar dirección'),
              ),
              if (widget.direccion.isNotEmpty)
                TextButton(
                  onPressed: () => Navigator.pop(context, ''),
                  child: const Text('Quitar dirección'),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
