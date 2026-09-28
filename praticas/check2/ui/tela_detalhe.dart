import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/habito.dart';
import '../dominio/habitos_store.dart';

class TelaDetalhe extends StatelessWidget {
  final Habito h;

  const TelaDetalhe({super.key, required this.h});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(h.nome)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(h.icone, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(h.nome, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(h.meta, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Excluir'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                context.read<HabitosStore>().remover(h);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
