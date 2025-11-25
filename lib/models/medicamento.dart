class Medicamento {
  final int id;
  final String nome;
  final int categoriaId;
  final String formatoId;
  final int viaAdministracaoId;
  final int tarjaId;
  final double precoMedio;
  final int laboratorioId;

  Medicamento({
    required this.id,
    required this.nome,
    required this.categoriaId,
    required this.formatoId,
    required this.viaAdministracaoId,
    required this.tarjaId,
    required this.precoMedio,
    required this.laboratorioId
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      id: json['id'],
      nome: json['name'],
      categoriaId: json['category_id'],
      formatoId: json['format_id'],
      viaAdministracaoId: json['admroute_id'],
      tarjaId: json['labelclass_id'],
      precoMedio: json['average_price'],
      laboratorioId: json['laboratory_id']
    );
  }

  @override
  String toString() => "Medicamento { "
        "id: $id, "
        "nome: $nome, "
        "categoriaId: $categoriaId, "
        "formatoId: $formatoId, "
        "viaAdministracaoId: $viaAdministracaoId, "
        "tarjaId: $tarjaId, "
        "precoMedio: $precoMedio, "
        "laboratorioId: $laboratorioId }";
}