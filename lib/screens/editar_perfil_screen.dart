import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({
    super.key,
    required this.nombre,
    required this.correo,
    required this.telefono,
  });

  final String nombre, correo, telefono;

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombre = TextEditingController(text: widget.nombre);
  late final _correo = TextEditingController(text: widget.correo);
  late final _telefono = TextEditingController(text: widget.telefono);

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, (
      nombre: _nombre.text.trim().replaceAll(RegExp(r'\s+'), ' '),
      correo: _correo.text.trim(),
      telefono: _telefono.text,
    ));
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _telefono.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F6F3),
    appBar: AppBar(title: const Text('Editar datos')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                controller: _nombre,
                maxLength: 60,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (valor) => (valor ?? '').trim().length < 2
                    ? 'Escribe un nombre de al menos 2 caracteres.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _correo,
                maxLength: 100,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: (valor) {
                  final correo = (valor ?? '').trim();
                  if (correo.isEmpty) return null;
                  return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(correo)
                      ? null
                      : 'Revisa el correo electrónico.';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefono,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  hintText: '10 dígitos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (valor) =>
                    valor == null || valor.isEmpty || valor.length == 10
                    ? null
                    : 'Escribe los 10 dígitos del teléfono.',
                onFieldSubmitted: (_) => _guardar(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _guardar,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Guardar cambios'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
