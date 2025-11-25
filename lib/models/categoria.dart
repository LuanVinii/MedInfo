class Categoria {
  final int id;
  final String nome;
  final String descricao;
  final String icone;     // identificador do ícone (nome Material ou asset path)

  Categoria({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.icone,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['name'],
      descricao: json['description'],
      icone: ''
    );
  }

  @override
  String toString() => "Categoria { id: $id, nome: $nome, descricao: $descricao }";
}