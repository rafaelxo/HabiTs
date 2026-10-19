import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dominio/pilotos_store.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PilotosStore(),
      child: const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'F1 Standings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  Color _obterCorDoPodio(String posicao) {
    switch (posicao) {
      case '1':
        return Colors.amber;
      case '2':
        return Colors.grey.shade400;
      case '3':
        return Colors.orange.shade300;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loja = context.watch<PilotosStore>();

    Widget conteudoDaTela;

    switch (loja.estado) {
      case Estado.carregando:
        conteudoDaTela = const Center(child: CircularProgressIndicator());
        break;

      case Estado.erro:
        conteudoDaTela = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sports_motorsports,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(loja.mensagemErro ?? 'Erro desconhecido'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => loja.carregar(),
                child: const Text('Tentar de novo'),
              ),
            ],
          ),
        );
        break;

      case Estado.vazio:
        conteudoDaTela = const Center(child: Text('Nenhum piloto encontrado.'));
        break;

      case Estado.pronto:
        conteudoDaTela = ListView.builder(
          itemCount: loja.pilotos.length,
          itemBuilder: (context, index) {
            final p = loja.pilotos[index];
            final isPodium = ['1', '2', '3'].contains(p.posicao);
            final corPodio = _obterCorDoPodio(p.posicao);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: isPodium ? 4 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: isPodium
                    ? BorderSide(color: corPodio, width: 2)
                    : BorderSide.none,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isPodium ? corPodio : Colors.grey.shade200,
                  child: Text(
                    p.posicao,
                    style: TextStyle(
                      color: isPodium ? Colors.black87 : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  p.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(p.equipe),
                trailing: Text(
                  '${p.pontos} pts',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Classificação F1',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: conteudoDaTela,
    );
  }
}
