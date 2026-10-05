import 'package:flutter/foundation.dart';

import 'habito.dart';
import '../dados/habitos_repositorio.dart';

class HabitosStore extends ChangeNotifier {
  final HabitosRepositorio _repo;
  List<Habito> _habitos = [];

  HabitosStore(this._repo) {
    carregar();
  }

  List<Habito> get habitos => List.unmodifiable(_habitos);

  Future<void> carregar() async {
    _habitos = await _repo.carregar();
    notifyListeners();
  }

  Future<void> adicionar(Habito h) async {
    await _repo.salvar(h);
    await carregar();
  }

  Future<void> remover(Habito h) async {
    await _repo.remover(h);
    await carregar();
  }
}
