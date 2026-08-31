import 'package:flutter/material.dart';

void main() => runApp(const AppReceitas());

class Receita {
  final String titulo;
  final String origem;
  final int tempo;
  final IconData icone;

  const Receita(this.titulo, this.origem, this.tempo, this.icone);
}

const receitas = [
  Receita('Pão de queijo', 'Minas Gerais', 40, Icons.bakery_dining),
  Receita('Moqueca', 'Bahia', 55, Icons.set_meal),
  Receita('Arroz carreteiro', 'Rio Grande do Sul', 35, Icons.rice_bowl),
];

class TelaReceitas extends StatelessWidget {
  const TelaReceitas({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Receitas'),
      actions: [
        IconButton(icon: const Icon(Icons.search),
        onPressed: () {})
      ],
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const Color(0xFFE3E8EF),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            '${receitas.length} receitas',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A5276),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: receitas.length,
            separatorBuilder: (context, i) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = receitas[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE3E8EF),
                  child: Icon(r.icone, color: const Color(0xFF1A5276)),
                ),
                title: Text(r.titulo),
                subtitle: Text('${r.origem} · ${r.tempo} minutos'),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    ),
  );
}

class AppReceitas extends StatelessWidget {
  const AppReceitas({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Receitas App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
      useMaterial3: true,
    ),
    home: const TelaReceitas(),
  );
}
