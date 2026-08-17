// Importa o pacote principal do Flutter com todos os widgets visuais
import 'package:flutter/material.dart';

// Ponto de entrada do app: quando o app abre, executa MyDiaryApp
void main() => runApp(const MyDiaryApp());

// Modelo de dados que representa um hábito
class Habit {
  final String name;
  final String goal;
  final IconData icon;

  // Construtor: recebe os três campos obrigatórios
  const Habit(this.name, this.goal, this.icon);
}

// Lista estática com os hábitos cadastrados no app
const habits = [
  Habit('Beber água',          'Meta: 8 copos por dia',    Icons.local_drink),
  Habit('Ler',                 'Meta: 20 páginas por dia', Icons.menu_book),
  Habit('Caminhar',            'Meta: 30 minutos por dia', Icons.directions_walk),
  Habit('Dormir cedo',         'Meta: antes das 23h',      Icons.bedtime),
  Habit('Estudar programação', 'Meta: 2 horas por dia',    Icons.computer),
];

// Simula uma busca assíncrona de hábitos (como se viesse de uma API)
// Aguarda 4 segundos antes de retornar a lista — imita um carregamento
Future<List<Habit>> fetchHabits() async {
  await Future.delayed(const Duration(seconds: 4));
  return habits;
}

// Widget responsável por exibir a lista de hábitos na tela
// Recebe um Future e aguarda ele terminar antes de renderizar
class DisplayHabits extends StatelessWidget {
  const DisplayHabits({super.key, required this.futureHabits});

  // O Future que será monitorado pelo FutureBuilder
  final Future<List<Habit>> futureHabits;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Meus Hábitos')),

    body: FutureBuilder<List<Habit>>(
      future: futureHabits, // Future que será observado
      
      builder: (context, snapshot) {
        // Enquanto o Future ainda não terminou, mostra um spinner de carregamento
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        // Se ocorreu algum erro durante o carregamento, exibe mensagem de erro
        if (snapshot.hasError) {
          return const Center(child: Text('Não foi possível carregar'));
        }
        // Pega a lista de hábitos retornada pelo Future
        final habits = snapshot.data!;
        // Se a lista estiver vazia, exibe mensagem informativa
        if (habits.isEmpty) {
          return const Center(child: Text('Nenhum hábito ainda'));
        }

        // Monta a lista rolável com um item (ListTile) para cada hábito
        return ListView(
          children: [
            for (final h in habits)
              ListTile(leading: Icon(h.icon), title: Text(h.name), subtitle: Text(h.goal)),
          ],
        );
      },
    ),
  );
}

// Widget raiz do aplicativo — configura o MaterialApp
class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    home: DisplayHabits(futureHabits: fetchHabits()), // Tela inicial
  );
}
