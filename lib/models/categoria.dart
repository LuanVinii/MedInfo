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
    // Converte id para int caso venha como String (comum em alguns bancos)
    final rawId = json['id'];
    final int id = rawId is int ? rawId : int.parse(rawId.toString());
    
    return Categoria(
      id: id,
      nome: json['name'] ?? '',
      descricao: json['description'] ?? '',
      icone: ''
    );
  }

  @override
  String toString() => "Categoria { id: $id, nome: $nome, descricao: $descricao }";
}