class IndicacaoUso {
  final int id;
  final String descricao;

  IndicacaoUso({
    required this.id,
    required this.descricao
  });

  factory IndicacaoUso.fromJson(Map<String, dynamic> json) {
    return IndicacaoUso(
      id: json['id'],
      descricao: json['description'],
    );
  }

  @override
  String toString() => "IndicacaoUso { id: $id, descricao: $descricao }";

}