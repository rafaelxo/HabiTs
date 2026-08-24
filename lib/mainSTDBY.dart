// Importa o pacote principal do Flutter com todos os widgets visuais
import 'package:flutter/material.dart';

// Ponto de entrada do app: quando o app abre, executa MyDiaryApp
void main() => runApp(const MyDiaryApp());

// Modelo de dados que representa um hábito
// Campos 'final' garantem imutabilidade após a criação
class Habit {
  final String name;   // Nome do hábito (ex: "Beber água")
  final String goal;   // Meta textual (ex: "20 páginas por dia")
  final IconData icon; // Ícone do Material Icons associado ao hábito

  // Construtor constante: permite instanciar em tempo de compilação (const)
  const Habit(this.name, this.goal, this.icon);
}

// Lista estática com os hábitos cadastrados no app
// 'const' garante que a lista é criada uma única vez e nunca alterada
const habits = [
  Habit('Beber água',          'Meta: 8 copos por dia',    Icons.local_drink),
  Habit('Ler',                 'Meta: 20 páginas por dia', Icons.menu_book),
  Habit('Caminhar',            'Meta: 30 minutos por dia', Icons.directions_walk),
  Habit('Dormir cedo',         'Meta: antes das 23h',      Icons.bedtime),
  Habit('Estudar programação', 'Meta: 2 horas por dia',    Icons.computer),
];

// Future: representa uma operação assíncrona que retornará um valor no futuro
// Simula uma busca de hábitos em uma API remota
// 'async' marca a função como assíncrona; 'await' pausa a execução até o Future terminar
Future<List<Habit>> fetchHabits() async {
  try {
    // Future.delayed: pausa a execução por 4 segundos, imitando uma chamada de rede
    await Future.delayed(const Duration(seconds: 4));
    return habits; // Retorna a lista após o delay
  } catch (e) {
    // Captura qualquer erro (ex: falha de rede, timeout) e relança com mensagem clara
    throw Exception('Erro ao carregar hábitos: $e');
  }
}

// Widget responsável por exibir a lista de hábitos na tela
// StatelessWidget: não tem estado interno — tudo vem pelo construtor
class DisplayHabits extends StatelessWidget {
  const DisplayHabits({super.key, required this.futureHabits});

  // Future que será monitorado pelo FutureBuilder para saber quando os dados chegam
  final Future<List<Habit>> futureHabits;

  @override
  // Usa a sintaxe de "arrow function" (=>) pois o build retorna diretamente um Scaffold
  Widget build(BuildContext context) => Scaffold(
    // AppBar: barra superior da tela com título
    appBar: AppBar(title: const Text('Meus Hábitos')),

    // FutureBuilder: widget reativo que reconstrói a UI conforme o estado do Future
    // Enquanto aguarda, durante o carregamento ou ao concluir, exibe conteúdo diferente
    body: FutureBuilder<List<Habit>>(
      future: futureHabits, // Future que será observado

      // builder: chamado sempre que o estado do Future muda
      // 'snapshot' contém: connectionState, data, error
      builder: (context, snapshot) {
        // ConnectionState.done: o Future terminou (com sucesso ou erro)
        // Enquanto não terminou, mostra um indicador de carregamento
        if (snapshot.connectionState != ConnectionState.done) {
          // CircularProgressIndicator: spinner animado de carregamento
          // Center: centraliza o filho tanto horizontal quanto verticalmente
          return const Center(child: CircularProgressIndicator());
        }
        // hasError: true se o Future lançou uma exceção
        if (snapshot.hasError) {
          return const Center(child: Text('Não foi possível carregar'));
        }

        // snapshot.data!: acessa o valor retornado pelo Future
        // O '!' afirma que não é null (já garantido por não ter hasError)
        final habits = snapshot.data!;

        // Lista vazia: exibe mensagem informativa no centro da tela
        if (habits.isEmpty) {
          return const Center(child: Text('Nenhum hábito cadastrado'));
        }

        // ListView: widget de lista rolável — renderiza itens sob demanda
        // Mais eficiente que Column para listas longas
        return ListView(
          children: [
            // Cria um ListTile para cada hábito da lista usando 'for' dentro do array
            for (final h in habits)
              // ListTile: item de lista padrão do Material Design
              // leading: widget à esquerda (ícone)
              // title: texto principal
              // subtitle: texto secundário abaixo do title
              ListTile(
                leading: Icon(h.icon),   // Ícone do hábito
                title: Text(h.name),     // Nome do hábito
                subtitle: Text(h.goal),  // Meta do hábito
              ),
          ],
        );
      },
    ),
  );
}

// Widget raiz do aplicativo — configura o MaterialApp
// StatelessWidget: apenas monta a estrutura base do app, sem estado
class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    // home: tela inicial — instancia DisplayHabits passando o Future de hábitos
    // fetchHabits() é chamado aqui e o Future é passado para baixo na árvore
    home: DisplayHabits(futureHabits: fetchHabits()),
  );
}

