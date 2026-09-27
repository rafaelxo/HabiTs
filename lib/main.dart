import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCard {
  final String titulo;
  final String subtitulo;
  final IconData icone;

  const ItemCard(this.titulo, this.subtitulo, this.icone);
}

class MeuAppStore extends ChangeNotifier {
  final List<ItemCard> _itens = [
    const ItemCard('Aprender Flutter', 'Categoria: Estudos', Icons.menu_book),
    const ItemCard('Fazer o Check', 'Categoria: Faculdade', Icons.task_alt),
  ];

  List<ItemCard> get itens => List.unmodifiable(_itens);

  void adicionar(ItemCard novoItem) {
    _itens.add(novoItem);
    notifyListeners();
  }
}

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => MeuAppStore(),
    child: const AppCheckBase(),
  ),
);

class AppCheckBase extends StatelessWidget {
  const AppCheckBase({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Check Base',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
      useMaterial3: true,
    ),
    home: const TelaLista(),
  );
}

class TelaLista extends StatelessWidget {
  const TelaLista({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    final listaDeItens = context.watch<MeuAppStore>().itens;

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Itens')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: cores.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '${listaDeItens.length} itens cadastrados',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cores.onPrimaryContainer,
              ),
            ),
          ),
          Expanded(
            child: listaDeItens.isEmpty
                ? const Center(child: Text('Nenhum item cadastrado'))
                : ListView.separated(
                    itemCount: listaDeItens.length,
                    separatorBuilder: (context, i) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = listaDeItens[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cores.primaryContainer,
                          child: Icon(item.icone, color: cores.primary),
                        ),
                        title: Text(item.titulo),
                        subtitle: Text(item.subtitulo),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TelaFormulario()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  const TelaFormulario({super.key});

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorTitulo = TextEditingController();
  final _controladorSubtitulo = TextEditingController();

  @override
  void dispose() {
    _controladorTitulo.dispose();
    _controladorSubtitulo.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_chaveFormulario.currentState!.validate()) {
      final novoItem = ItemCard(
        _controladorTitulo.text.trim(),
        'Categoria: ${_controladorSubtitulo.text.trim()}',
        Icons.star,
      );

      context.read<MeuAppStore>().adicionar(novoItem);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Novo Item')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _chaveFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controladorTitulo,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Informe o título' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controladorSubtitulo,
              decoration: const InputDecoration(
                labelText: 'Categoria / Subtítulo',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Informe a categoria' : null,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _salvar, child: const Text('Salvar Item')),
          ],
        ),
      ),
    ),
  );
}
