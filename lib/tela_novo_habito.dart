import 'package:flutter/material.dart';

import 'main.dart';

class TelaNovoHabito extends StatefulWidget {
  const TelaNovoHabito({super.key});

  @override
  State<TelaNovoHabito> createState() => _TelaNovoHabitoState();
}

class _TelaNovoHabitoState extends State<TelaNovoHabito> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorNome = TextEditingController();
  final _controladorMeta = TextEditingController();

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorMeta.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_chaveFormulario.currentState!.validate()) {
      final novoHabito = Habito(
        _controladorNome.text.trim(),
        'Meta: ${_controladorMeta.text.trim()}',
        Icons.star,
      );
      Navigator.pop(context, novoHabito);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Novo Hábito')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _chaveFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controladorNome,
              decoration: const InputDecoration(
                labelText: 'Nome do hábito',
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Informe o nome';
                }
                if (valor.trim().length < 3) {
                  return 'Use ao menos 3 letras';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controladorMeta,
              decoration: const InputDecoration(
                labelText: 'Meta diária',
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Informe a meta';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _salvar, child: const Text('Salvar')),
          ],
        ),
      ),
    ),
  );
}
