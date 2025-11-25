class IndicacaoUso {
  final int id;
  final String nome;

  IndicacaoUso({
    required this.id,
    required this.nome
  });

  factory IndicacaoUso.fromJson(Map<String, dynamic> json) {
    return IndicacaoUso(
      id: json['id'],
      nome: json['name'],
    );
  }

  @override
  String toString() => "IndicacaoUso { id: $id, nome: $nome }";

}