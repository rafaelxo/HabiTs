import 'package:flutter/material.dart';

class Habito {
  final int? id;
  final String nome;
  final String meta;
  final int iconeCode;

  const Habito({
    this.id,
    required this.nome,
    required this.meta,
    required this.iconeCode,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'nome': nome,
    'meta': meta,
    'icone': iconeCode,
  };

  factory Habito.fromMap(Map<String, Object?> m) => Habito(
    id: m['id'] as int?,
    nome: m['nome'] as String,
    meta: m['meta'] as String,
    iconeCode: m['icone'] as int,
  );

  IconData get icone => IconData(iconeCode, fontFamily: 'MaterialIcons');
}
