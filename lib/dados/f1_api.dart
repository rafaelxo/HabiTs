import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dominio/piloto.dart';

class F1Api {
  Future<List<Piloto>> carregar() async {
    final url = Uri.parse(
      'https://api.jolpi.ca/ergast/f1/current/driverStandings.json',
    );

    final resposta = await http.get(url).timeout(const Duration(seconds: 10));

    if (resposta.statusCode != 200) {
      throw Exception('O servidor respondeu com ${resposta.statusCode}');
    }

    final Map<String, dynamic> bruto = jsonDecode(resposta.body);

    try {
      final listas =
          bruto['MRData']['StandingsTable']['StandingsLists'] as List<dynamic>;
      if (listas.isEmpty) return [];

      final resultados = listas[0]['DriverStandings'] as List<dynamic>;

      return resultados
          .map((m) => Piloto.fromMap(m as Map<String, Object?>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
