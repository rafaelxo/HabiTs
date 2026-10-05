import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dados/habitos_repositorio.dart';
import 'dados/preferencias.dart';
import 'dominio/habitos_store.dart';
import 'dominio/tema_store.dart';
import 'ui/tela_habitos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repositorio = HabitosRepositorio();
  final temaEscuro = await Preferencias.lerTema();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitosStore(repositorio)),
        ChangeNotifierProvider(create: (_) => TemaStore(temaEscuro)),
      ],
      child: const MeuDiarioApp(),
    ),
  );
}

class MeuDiarioApp extends StatelessWidget {
  const MeuDiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final escuro = context.watch<TemaStore>().escuro;

    return MaterialApp(
      title: 'HabiTs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: escuro ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.lightBlueAccent,
        useMaterial3: true,
      ),
      home: const TelaHabitos(),
    );
  }
}
