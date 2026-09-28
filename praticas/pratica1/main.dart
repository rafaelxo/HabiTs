import 'package:flutter/material.dart';

void main() => runApp(const MyDiaryApp());

class Habit {
  final String name;
  final String goal;
  final IconData icon;

  const Habit(this.name, this.goal, this.icon);
}

const habits = [
  Habit('Beber água', 'Meta: 8 copos por dia', Icons.local_drink),
  Habit('Ler', 'Meta: 20 páginas por dia', Icons.menu_book),
  Habit('Caminhar', 'Meta: 30 minutos por dia', Icons.directions_walk),
  Habit('Dormir cedo', 'Meta: antes das 23h', Icons.bedtime),
  Habit('Estudar programação', 'Meta: 2 horas por dia', Icons.computer),
];

Future<List<Habit>> fetchHabits() async {
  try {
    await Future.delayed(const Duration(seconds: 4));
    return habits;
  } catch (e) {
    throw Exception('Erro ao carregar hábitos: $e');
  }
}

class DisplayHabits extends StatelessWidget {
  const DisplayHabits({super.key, required this.futureHabits});

  final Future<List<Habit>> futureHabits;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Meus Hábitos')),
    body: FutureBuilder<List<Habit>>(
      future: futureHabits,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Não foi possível carregar'));
        }

        final habits = snapshot.data!;

        if (habits.isEmpty) {
          return const Center(child: Text('Nenhum hábito cadastrado'));
        }

        return ListView(
          children: [
            for (final h in habits)
              ListTile(
                leading: Icon(h.icon),
                title: Text(h.name),
                subtitle: Text(h.goal),
              ),
          ],
        );
      },
    ),
  );
}

class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    home: DisplayHabits(futureHabits: fetchHabits()),
  );
}
