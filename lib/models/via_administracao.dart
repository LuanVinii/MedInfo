class ViaAdministracao {
  final int id;
  final String nome;

  ViaAdministracao({
    required this.id,
    required this.nome
  });

  factory ViaAdministracao.fromJson(Map<String, dynamic> json) {
    return ViaAdministracao(
      id: json['id'],
      nome: json['name'],
    );
  }

  @override
  String toString() => "ViaAdministracao { id: $id, nome: $nome }";

}