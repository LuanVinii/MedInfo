import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/categoria.dart';
import '/models/medicamento.dart';
import '/models/usuario.dart';
import '/services/medicamento.dart';

class MedicamentoRepository {
  final MedicamentoService service;
  final SupabaseClient _supabase = Supabase.instance.client;

  MedicamentoRepository({MedicamentoService? service}) : service = service ?? MedicamentoService();

  Future<List<Medicamento>> buscarPorNome(String nome) async {
    return await service.buscarPorNome(nome);
  }

  Future<List<Medicamento>> buscarPorIndicacaoUso(String indicacaoUso) async {
    return await service.buscarPorIndicacaoUso(indicacaoUso);
  }

  Future<List<Medicamento>> buscarPorPrincipioAtivo(String principioAtivo) async {
    return await service.buscarPorPrincipioAtivo(principioAtivo);
  }

  Future<List<Medicamento>> buscarPorTermo(String termo) async {
    return await service.buscarPorTermo(termo);
  }

  Future<List<Medicamento>> obterPorCategoria(Categoria categoria) async {
    return await service.obterPorCategoria(categoria);
  }

  Future<Medicamento> obterPorId(int id) async {
    return await service.obterPorId(id);
  }

  Future<List<Medicamento>> obterPorUsuario(Usuario usuario) async {
    var registros = await _supabase.from('user_medicine')
        .select('medicine_id, medicines(id,name,average_price,categories(*),formats(*),admroutes(*),labelclasses(*),laboratories(*))')
        .eq('user_id', usuario.id);
        
    return registros.map((objeto) => Medicamento.fromJson(objeto['medicines'])).toList();
  }

  Future<List<Medicamento>> buscarPorTermoNaCategoria(String termo, Categoria categoria) async {
    List<Medicamento> medicamentos = await buscarPorTermo(termo);
    return medicamentos.where((medicamento) => medicamento.categoria.id == categoria.id).toList();
  }

  Future<void> salvarFavorito(int userId, Medicamento medicamento) async {
    if (userId == null) {
        throw Exception("ID de Usuário inválido.");
    }
      
    await _supabase.from('user_medicine').insert({
      'user_id': userId,
      'medicine_id': medicamento.id,
    });
  }
  
  Future<void> removerFavorito(int userId, Medicamento medicamento) async {
    if (userId == null) {
        throw Exception("ID de Usuário inválido.");
    }
      
    await _supabase.from('user_medicine').delete().match({
      'user_id': userId,
      'medicine_id': medicamento.id,
    });
  }
}