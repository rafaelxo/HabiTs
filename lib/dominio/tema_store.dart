import 'package:flutter/material.dart';

import '../dados/preferencias.dart';

class TemaStore extends ChangeNotifier {
  bool _escuro;

  TemaStore(this._escuro);

  bool get escuro => _escuro;

  Future<void> alternar() async {
    _escuro = !_escuro;
    await Preferencias.salvarTema(_escuro);
    notifyListeners();
  }
}
