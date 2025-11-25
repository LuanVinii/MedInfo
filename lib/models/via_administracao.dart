class ViaAdministracao {
  final int id;
  final String descricao;

  ViaAdministracao({
    required this.id,
    required this.descricao
  });

  factory ViaAdministracao.fromJson(Map<String, dynamic> json) {
    return ViaAdministracao(
      id: json['id'],
      descricao: json['description'],
    );
  }

  @override
  String toString() => "ViaAdministracao { id: $id, nome: $descricao }";

}