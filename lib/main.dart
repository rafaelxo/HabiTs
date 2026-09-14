import 'package:flutter/material.dart';

import 'form.dart';

void main() => runApp(const MeuDiarioApp());

class Habito {
  final String nome;
  final String meta;
  final IconData icone;

  const Habito(this.nome, this.meta, this.icone);
}

const habitosIniciais = [
  Habito('Beber água', 'Meta: 8 copos por dia', Icons.local_drink),
  Habito('Ler', 'Meta: 20 páginas por dia', Icons.menu_book),
  Habito('Caminhar', 'Meta: 30 minutos por dia', Icons.directions_walk),
  Habito('Dormir cedo', 'Meta: antes das 23h', Icons.bedtime),
  Habito('Estudar programação', 'Meta: 2 horas por dia', Icons.computer),
];

Future<List<Habito>> carregarHabitos() async {
  try {
    await Future.delayed(const Duration(seconds: 2));
    return habitosIniciais;
  } catch (e) {
    throw Exception('Erro ao carregar hábitos: $e');
  }
}

class MeuDiarioApp extends StatelessWidget {
  const MeuDiarioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
      useMaterial3: true,
    ),
    home: TelaHabitos(habitosFuturos: carregarHabitos()),
  );
}

class TelaHabitos extends StatefulWidget {
  const TelaHabitos({super.key, required this.habitosFuturos});

  final Future<List<Habito>> habitosFuturos;

  @override
  State<TelaHabitos> createState() => _TelaHabitosState();
}

class _TelaHabitosState extends State<TelaHabitos> {
  List<Habito> _habitos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    widget.habitosFuturos
        .then((habitosCarregados) {
          setState(() {
            _habitos = List.from(habitosCarregados);
            _carregando = false;
          });
        })
        .catchError((_) {
          setState(() {
            _carregando = false;
          });
        });
  }

  Future<void> _abrirNovoHabito() async {
    final novo = await Navigator.push<Habito>(
      context,
      MaterialPageRoute(builder: (_) => const TelaNovoHabito()),
    );

    if (!mounted) return;
    if (novo != null) {
      setState(() => _habitos.add(novo));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Meus Hábitos')),
    body: _carregando
        ? const Center(child: CircularProgressIndicator())
        : _habitos.isEmpty
        ? const Center(child: Text('Nenhum hábito cadastrado'))
        : ListView.separated(
            itemCount: _habitos.length,
            separatorBuilder: (context, i) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final h = _habitos[i];
              return ListTile(
                leading: Icon(h.icone),
                title: Text(h.nome),
                subtitle: Text(h.meta),
              );
            },
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: _abrirNovoHabito,
      child: const Icon(Icons.add),
    ),
  );
}
