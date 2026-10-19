class Piloto {
  final String posicao;
  final String nome;
  final String equipe;
  final String pontos;

  const Piloto({
    required this.posicao,
    required this.nome,
    required this.equipe,
    required this.pontos,
  });

  factory Piloto.fromMap(Map<String, Object?> m) {
    final driver = m['Driver'] as Map<String, dynamic>? ?? {};
    final constructors = m['Constructors'] as List<dynamic>? ?? [];

    final equipeNome = constructors.isNotEmpty
        ? constructors[0]['name'] as String? ?? 'Sem equipe'
        : 'Sem equipe';

    final nome = driver['givenName'] as String? ?? '';
    final sobrenome = driver['familyName'] as String? ?? '';

    return Piloto(
      posicao: m['position'] as String? ?? '-',
      nome: '$nome $sobrenome'.trim(),
      equipe: equipeNome,
      pontos: m['points'] as String? ?? '0',
    );
  }
}
