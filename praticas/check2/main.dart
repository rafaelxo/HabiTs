import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dados/habitos_repositorio.dart';
import 'dominio/habitos_store.dart';
import 'ui/tela_habitos.dart';

void main() {
  final repositorio = HabitosRepositorio();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitosStore(repositorio),
      child: const MeuDiarioApp(),
    ),
  );
}

class MeuDiarioApp extends StatelessWidget {
  const MeuDiarioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'HabiTs',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      useMaterial3: true,
    ),
    home: const TelaHabitos(),
  );
}
