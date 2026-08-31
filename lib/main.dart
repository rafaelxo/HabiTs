// Importa o pacote principal do Flutter, que contém todos os widgets visuais
// (MaterialApp, Scaffold, Text, Icon, etc.)
import 'package:flutter/material.dart';

// Ponto de entrada do app: quando o app abre, executa MyDiaryApp
void main() => runApp(const MyDiaryApp());

// Modelo de dados que representa um hábito
// Usa campos 'final' (imutáveis) porque um hábito não muda depois de criado
class Habit {
  final String name;   // Nome do hábito (ex: "Beber água")
  final String goal;   // Meta textual (ex: "8 copos por dia")
  final IconData icon; // Ícone do Material Icons que representa o hábito

  // Construtor constante: permite criar instâncias em tempo de compilação (const)
  const Habit(this.name, this.goal, this.icon);
}

// Widget raiz do aplicativo — configura o MaterialApp e o tema global
// StatelessWidget: não tem estado interno, só monta a árvore de widgets
class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {

    // MaterialApp: widget que habilita navegação, temas e rotas do Material Design
    return MaterialApp(

      // ThemeData: define o tema visual global (cores, fontes, formas)
      theme: ThemeData(

        // ColorScheme.fromSeed: gera automaticamente uma paleta de cores harmoniosa
        // a partir de uma cor semente (seedColor)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
        useMaterial3: true, // Ativa os componentes visuais do Material Design 3
      ),

      // home: define a tela inicial exibida quando o app abre
      home: const HabitDetailsScreen(
        habit: Habit('Beber água', 'Meta: 8 copos por dia', Icons.local_drink),
      ),
    );
  }
}

// Tela de detalhes de um hábito específico
// StatelessWidget: não precisa de estado porque todos os dados vêm pelo construtor
class HabitDetailsScreen extends StatelessWidget {
  final Habit habit; // O hábito cujos detalhes serão exibidos

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {

    // Theme.of(context): acessa o tema definido no MaterialApp mais próximo na árvore
    // colorScheme: paleta de cores gerada pelo ThemeData
    final colors = Theme.of(context).colorScheme;

    // textTheme: conjunto de estilos de texto pré-definidos (titleLarge, bodyMedium, etc.)
    final texts = Theme.of(context).textTheme;

    // Scaffold: estrutura básica de uma tela Material Design
    // Fornece AppBar, body, FAB, Drawer, SnackBar, etc.
    return Scaffold(

      // AppBar: barra superior da tela com título e ações
      appBar: AppBar(
        title: Text(habit.name), // Exibe o nome do hábito como título
        leading: IconButton(     // 'leading': widget à esquerda da AppBar
          icon: const Icon(Icons.arrow_back), // Ícone de voltar
          onPressed: () {},                   // Ação ao pressionar (sem efeito por enquanto)
        ),
      ),

      // SingleChildScrollView: torna o conteúdo rolável quando ele ultrapassa
      // a altura da tela — evita overflow (estouro de conteúdo)
      body: SingleChildScrollView(

        // Column: organiza os filhos verticalmente, um abaixo do outro
        child: Column(

          // CrossAxisAlignment.stretch: estica cada filho horizontalmente
          // para ocupar toda a largura disponível da Column
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // BANNER SUPERIOR (ícone + nome + meta)
            // Container: caixa genérica para aplicar cor, padding, tamanho e decorações
            Container(
              width: double.infinity, // Ocupa toda a largura disponível
              color: colors.primary,  // Cor de fundo: cor primária do tema

              // EdgeInsets.symmetric: define padding (espaço interno) nas direções
              // horizontal (esquerda/direita) e vertical (cima/baixo)
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),

              // Row: organiza os filhos horizontalmente, lado a lado
              child: Row(
                children: [

                  // CircleAvatar: widget circular, geralmente usado para avatares/ícones
                  // O externo serve como borda (backgroundColor = surface)
                  CircleAvatar(
                    radius: 34, // Raio do círculo externo — define o tamanho da borda
                    backgroundColor: colors.surface, // Cor de borda: contrasta com o fundo primary

                    // CircleAvatar interno: contém o ícone do hábito
                    child: CircleAvatar(
                      radius: 30, // Raio menor que o externo, criando o efeito de borda
                      backgroundColor: colors.primaryContainer, // Fundo do container do ícone
                      child: Icon(
                        habit.icon,
                        size: 32,
                        color: colors.onPrimaryContainer, // Cor que contrasta com primaryContainer
                      ),
                    ),
                  ),

                  // SizedBox: espaçador com tamanho fixo
                  // Aqui cria um espaço horizontal de 16px entre o avatar e o texto
                  const SizedBox(width: 16),

                  // Expanded: faz o filho ocupar todo o espaço horizontal restante na Row
                  // Sem ele, o texto poderia transbordar ou não se ajustar corretamente
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
                      children: [
                        Text(
                          habit.name,

                          // style: define o estilo visual do texto
                          // texts.titleLarge: estilo grande de título do tema
                          // .copyWith: copia o estilo base e sobrescreve propriedades específicas
                          style: texts.titleLarge?.copyWith(
                            color: colors.onPrimary,          // Cor que contrasta com primary
                            fontWeight: FontWeight.bold,       // Deixa o texto em negrito
                          ),
                        ),

                        const SizedBox(height: 8), // Espaço vertical de 8px

                        Text(
                          habit.goal,

                          // titleMedium: estilo de título médio, menor que titleLarge
                          style: texts.titleMedium?.copyWith(
                            color: colors.onPrimary, // Cor legível sobre o fundo primary
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Espaço vertical entre seções

            // CARDS DE ESTATÍSTICAS (Ofensiva / Diária / Mensal)
            // Padding: adiciona espaço interno ao redor do seu filho
            // EdgeInsets.symmetric(horizontal): só aplica nas laterais (esquerda e direita)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),

              // Row com três Cards de estatísticas lado a lado
              child: Row(
                children: [

                  // Expanded: cada Card ocupa 1/3 igual do espaço horizontal da Row
                  Expanded(

                    // Card: widget que aplica sombra, borda arredondada e cor de superfície
                    // Cria o visual de "cartão" do Material Design
                    child: Card(

                      // Padding interno do Card para não colar o conteúdo nas bordas
                      child: Padding(

                        // EdgeInsets.symmetric(vertical): aplica só em cima e embaixo
                        padding: const EdgeInsets.symmetric(vertical: 16.0),

                        // Column sem crossAxisAlignment = centraliza os filhos por padrão
                        child: Column(
                          children: [

                            // Valor principal do card em destaque
                            Text(
                              '12 dias',
                              style: texts.titleLarge?.copyWith(
                                color: colors.primary,      // Usa a cor primária para destaque
                                fontWeight: FontWeight.bold, // Negrito para chamar atenção
                              ),
                            ),
                            const SizedBox(height: 4), // Pequeno espaço entre valor e rótulo
                            // bodySmall: menor estilo de texto do tema, ideal para rótulos
                            Text(
                              'Ofensiva',
                              style: texts.bodySmall?.copyWith(
                                color: colors.onSurface, // Cor neutra de leitura
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Expanded: 2º card ocupa mais 1/3 do espaço horizontal da Row
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),

                        // Column sem crossAxisAlignment = centraliza os filhos por padrão
                        child: Column(
                          children: [

                            // Valor principal do card em destaque
                            Text(
                              '6 / 8', // Progresso do dia: copos bebidos / meta
                              style: texts.titleLarge?.copyWith(
                                color: colors.primary,       // Usa a cor primária para destaque
                                fontWeight: FontWeight.bold,  // Negrito para chamar atenção
                              ),
                            ),
                            const SizedBox(height: 4), // Pequeno espaço entre valor e rótulo

                            // bodySmall: menor estilo de texto do tema, ideal para rótulos
                            Text(
                              'Diária',
                              style: texts.bodySmall?.copyWith(
                                color: colors.onSurface, // Cor neutra de leitura
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Expanded: 3º card ocupa o último 1/3 do espaço horizontal da Row
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),

                        // Column sem crossAxisAlignment = centraliza os filhos por padrão
                        child: Column(
                          children: [

                            // Valor principal do card em destaque
                            Text(
                              '62%', // Taxa de conclusão mensal do hábito
                              style: texts.titleLarge?.copyWith(
                                color: colors.primary,       // Usa a cor primária para destaque
                                fontWeight: FontWeight.bold,  // Negrito para chamar atenção
                              ),
                            ),
                            const SizedBox(height: 4), // Pequeno espaço entre valor e rótulo
                            // bodySmall: menor estilo de texto do tema, ideal para rótulos
                            Text(
                              'Mensal',
                              style: texts.bodySmall?.copyWith(
                                color: colors.onSurface, // Cor neutra de leitura
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CARD COM BLOCO DE TEXTO ("Sobre o hábito")
            // Padding: recua o Card 16px de cada lado para não encostar nas bordas da tela
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              // Card: cria o visual de cartão com sombra e bordas arredondadas
              child: Card(

                // Padding interno: EdgeInsets.all aplica o mesmo espaço nos 4 lados
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinha texto à esquerda
                    children: [
                      Text(
                        'Sobre o hábito',

                        // style: usa o estilo titleMedium do tema e sobrescreve cor e peso
                        style: texts.titleMedium?.copyWith(
                          color: colors.primary,       // Destaca o título com a cor primária
                          fontWeight: FontWeight.bold,  // Negrito para separar do corpo do texto
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'A consistência é a chave para o sucesso. Manter um acompanhamento diário ajuda a solidificar este hábito na sua rotina. Continue se esforçando e não desanime se perder um dia!',

                        // bodyMedium: estilo padrão para textos de conteúdo/corpo
                        style: texts.bodyMedium?.copyWith(
                          color: colors.onSurface, // Cor legível sobre a superfície do Card
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // Espaço final para não colar no fim da tela
          ],
        ),
      ),
    );
  }
}
