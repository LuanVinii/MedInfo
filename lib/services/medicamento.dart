import 'package:medinfo/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/models/categoria.dart';
import '/models/medicamento.dart';

class MedicamentoService {
  static final SupabaseClient _client = Supabase.instance.client;

  Future<List<Medicamento>> buscarPorNome(String nome) async {
    var registros = await _client.from('medicines')
        .select(_MedicamentoQuery.infos)
        .ilike('name', '%$nome%');
    return registros.map((objeto) => Medicamento.fromJson(objeto)).toList();
  }

  Future<List<Medicamento>> buscarPorIndicacaoUso(String indicacaoUso) async {
    var registros = await _client.from('medicine_indication')
        .select('${_MedicamentoQuery.infosComTabela}, ${_IndicacaoUsoQuery.infosComTabela}')
        .ilike('indications.description', '%$indicacaoUso%');
    return registros.map((objeto) => Medicamento.fromJson(objeto['medicines'])).toList();
  }

  Future<List<Medicamento>> buscarPorPrincipioAtivo(String principioAtivo) async {
    var registros = await _client.from('medicine_ingredient')
        .select('${_MedicamentoQuery.infosComTabela}, ${_PrincipioAtivoQuery.infosComTabela}')
        .ilike('ingredients.name', '%$principioAtivo%');
    return registros.map((objeto) => Medicamento.fromJson(objeto['medicines'])).toList();
  }

  Future<List<Medicamento>> buscarPorTermo(String termo) async {
    return [
      ... await buscarPorNome(termo),
      ... await buscarPorPrincipioAtivo(termo),
      ... await buscarPorIndicacaoUso(termo),
    ];
  }

  Future<List<Medicamento>> obterPorCategoria(Categoria categoria) async {
    var registros = await _client.from('medicines')
        .select(_MedicamentoQuery.infos)
        .eq('category_id', categoria.id);
    return registros.map((json) => Medicamento.fromJson(json)).toList();
  }

  Future<Medicamento> obterPorId(int id) async {
    var registro = await _client.from('medicines')
        .select(_MedicamentoQuery.infos)
        .eq('id', id).single();
    return Medicamento.fromJson(registro);
  }

  Future<List<Medicamento>> obterPorUsuario(Usuario usuario) async {
    var registros = await _client.from('user_medicine')
        .select(_MedicamentoQuery.infosComTabela)
        .eq('user_id', usuario.id);
    return registros.map((objeto) => Medicamento.fromJson(objeto['medicines'])).toList();
  }

}

class _MedicamentoQuery {
  static final infos = 'id,name,average_price,categories(*),formats(*),admroutes(*),labelclasses(*),laboratories(*)';
  static final infosComTabela = 'medicines(${_MedicamentoQuery.infos})';
}

class _PrincipioAtivoQuery {
  static final infosComTabela = 'ingredients(*)';

}

class _IndicacaoUsoQuery {
  static final infosComTabela = 'indications(*)';
}