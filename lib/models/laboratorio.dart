class Laboratorio {
  final int id;
  final String nome;

  Laboratorio({
    required this.id,
    required this.nome
  });

  factory Laboratorio.fromJson(Map<String, dynamic> json) {
    return Laboratorio(
      id: json['id'],
      nome: json['name'],
    );
  }

  @override
  String toString() => "Laboratorio { id: $id, nome: $nome }";

}