class Tarja {
  final int id;
  final String nome;

  Tarja({
    required this.id,
    required this.nome
  });

  factory Tarja.fromJson(Map<String, dynamic> json) {
    return Tarja(
      id: json['id'],
      nome: json['name'],
    );
  }

  @override
  String toString() => "Tarja { id: $id, nome: $nome }";

}