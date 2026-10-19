import 'package:flutter/material.dart';

import '../dados/f1_api.dart';
import 'piloto.dart';

enum Estado { carregando, pronto, vazio, erro }

class PilotosStore extends ChangeNotifier {
  final F1Api _api = F1Api();

  List<Piloto> _pilotos = [];
  Estado estado = Estado.carregando;
  String? mensagemErro;

  List<Piloto> get pilotos => List.unmodifiable(_pilotos);

  PilotosStore() {
    carregar();
  }

  Future<void> carregar() async {
    estado = Estado.carregando;
    notifyListeners();

    try {
      final resultado = await _api.carregar();
      if (resultado.isEmpty) {
        estado = Estado.vazio;
      } else {
        _pilotos = resultado;
        estado = Estado.pronto;
      }
    } catch (e) {
      estado = Estado.erro;
      mensagemErro = 'Sem conexão ou servidor indisponível. Tente de novo.';
    }

    notifyListeners();
  }
}
