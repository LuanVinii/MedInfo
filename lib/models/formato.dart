class Formato {
  final int id;
  final String descricao;

  Formato({
    required this.id,
    required this.descricao
  });

  factory Formato.fromJson(Map<String, dynamic> json) {
    return Formato(
      id: json['id'],
      descricao: json['description'],
    );
  }

  @override
  String toString() => "Formato { id: $id, descricao: $descricao }";

}