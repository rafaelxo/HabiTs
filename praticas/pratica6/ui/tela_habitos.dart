import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dominio/habitos_store.dart';
import '../dominio/tema_store.dart';
import 'tela_detalhe.dart';
import 'tela_novo.dart';

class TelaHabitos extends StatelessWidget {
  const TelaHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    final habitos = context.watch<HabitosStore>().habitos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Hábitos'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<TemaStore>().escuro
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<TemaStore>().alternar(),
          ),
        ],
      ),
      body: habitos.isEmpty
          ? const Center(child: Text('Nenhum hábito sobrando!'))
          : ListView.separated(
              itemCount: habitos.length,
              separatorBuilder: (context, i) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final h = habitos[i];
                return ListTile(
                  leading: Icon(
                    h.icone,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(h.nome),
                  subtitle: Text(h.meta),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TelaDetalhe(h: h)),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TelaNovoHabito()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
