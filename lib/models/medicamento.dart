import 'package:medinfo/models/categoria.dart';
import 'package:medinfo/models/formato.dart';
import 'package:medinfo/models/laboratorio.dart';
import 'package:medinfo/models/tarja.dart';
import 'package:medinfo/models/via_administracao.dart';

class Medicamento {
  final int id;
  final String nome;
  final Categoria categoria;
  final Formato formato;
  final ViaAdministracao viaAdministracao;
  final Tarja tarja;
  final double precoMedio;
  final Laboratorio laboratorio;

  Medicamento({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.formato,
    required this.viaAdministracao,
    required this.tarja,
    required this.precoMedio,
    required this.laboratorio
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      id: json['id'],
      nome: json['name'],
      categoria: Categoria.fromJson(json['categories']),
      formato: Formato.fromJson(json['formats']),
      viaAdministracao: ViaAdministracao.fromJson(json['admroutes']),
      tarja: Tarja.fromJson(json['labelclasses']),
      precoMedio: json['average_price'],
      laboratorio: Laboratorio.fromJson(json['laboratories'])
    );
  }

  @override
  String toString() => "Medicamento { "
        "id: $id, "
        "nome: $nome, "
        "categoria: $categoria, "
        "formato: $formato, "
        "viaAdministracao: $viaAdministracao, "
        "tarja: $tarja, "
        "precoMedio: $precoMedio, "
        "laboratorio: $laboratorio }";
}