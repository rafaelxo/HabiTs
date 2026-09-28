import 'package:flutter/material.dart';

import '../dominio/habito.dart';

class HabitosRepositorio {
  final List<Habito> _memoria = [
    const Habito('Beber água', 'Meta: 8 copos por dia', Icons.local_drink),
    const Habito('Ler', 'Meta: 20 páginas por dia', Icons.menu_book),
    const Habito('Caminhar', 'Meta: 30 minutos por dia', Icons.directions_walk),
    const Habito('Estudar programação', 'Meta: 1 hora por dia', Icons.computer),
  ];

  Future<List<Habito>> carregar() async => List.of(_memoria);

  Future<void> salvar(Habito h) async {
    _memoria.add(h);
  }

  Future<void> remover(Habito h) async {
    _memoria.remove(h);
  }
}
