class Formato {
  final int id;
  final String nome;

  Formato({
    required this.id,
    required this.nome
  });

  factory Formato.fromJson(Map<String, dynamic> json) {
    return Formato(
      id: json['id'],
      nome: json['name'],
    );
  }

  @override
  String toString() => "Formato { id: $id, nome: $nome }";

}