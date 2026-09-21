import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../macos/pratica5_store.dart';
import 'pratica5_form.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => HabitosStore(),
    child: const MeuDiarioApp(),
  ),
);

class MeuDiarioApp extends StatelessWidget {
  const MeuDiarioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
      useMaterial3: true,
    ),
    home: const TelaHabitos(),
  );
}

class TelaHabitos extends StatelessWidget {
  const TelaHabitos({super.key});

  void _abrirNovoHabito(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaNovoHabito()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitos = context.watch<HabitosStore>().habitos;

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Hábitos')),
      body: habitos.isEmpty
          ? const Center(child: Text('Nenhum hábito cadastrado'))
          : ListView.separated(
              itemCount: habitos.length,
              separatorBuilder: (context, i) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final h = habitos[i];
                return ListTile(
                  leading: Icon(h.icone),
                  title: Text(h.nome),
                  subtitle: Text(h.meta),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirNovoHabito(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
