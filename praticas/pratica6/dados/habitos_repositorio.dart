import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../dominio/habito.dart';

class HabitosRepositorio {
  Future<Database> _abrir() async => openDatabase(
    join(await getDatabasesPath(), 'habitos.db'),
    version: 1,
    onCreate: (db, _) => db.execute(
      'CREATE TABLE habitos('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'nome TEXT NOT NULL, '
      'meta TEXT NOT NULL, '
      'icone INTEGER NOT NULL)',
    ),
  );

  Future<List<Habito>> carregar() async {
    final db = await _abrir();
    final linhas = await db.query('habitos');
    return linhas.map(Habito.fromMap).toList();
  }

  Future<void> salvar(Habito h) async {
    final db = await _abrir();
    await db.insert('habitos', h.toMap());
  }

  Future<void> remover(Habito h) async {
    if (h.id != null) {
      final db = await _abrir();
      await db.delete('habitos', where: 'id = ?', whereArgs: [h.id]);
    }
  }
}
