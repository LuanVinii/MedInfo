class PrincipioAtivo {
  final int id;
  final String nome;

  PrincipioAtivo({
    required this.id,
    required this.nome
  });

  factory PrincipioAtivo.fromJson(Map<String, dynamic> json) {
    return PrincipioAtivo(
      id: json['id'],
      nome: json['name'],
    );
  }

  @override
  String toString() => "PrincipioAtivo { id: $id, nome: $nome }";

}