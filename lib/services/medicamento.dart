import 'package:medinfo/models/categoria.dart';
import 'package:medinfo/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/models/medicamento.dart';

class MedicamentoService {

  Future<Medicamento> obterPorId(int id) async {
    var json = await Supabase.instance.client.from('medicines').select().eq('id', id).limit(1).single();
    return Medicamento.fromJson(json);
  }

  Future<List<Medicamento>> obterPorCategoria(Categoria categoria) async {
    var dadosBrutos = await Supabase.instance.client.from('medicines').select().eq('category_id', categoria.id);
    return dadosBrutos.map((json) => Medicamento.fromJson(json)).toList();
  }
  //
  // Future<List<Medicamento>> obterPorUsuario(Usuario usuario) async {
  //
  //
  //
  //
  //
  //
  //
  //
  //   var dadosBrutos = await Supabase.instance.client.from('user_medicine').select('medicine_id').eq('user_id', usuario.id);
  //
  //
  //
  //
  //   return dadosBrutos.map((json) => Medicamento.fromJson(json)).toList();
  // }
  //
  //
  //
  //




}