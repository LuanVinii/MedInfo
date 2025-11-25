import 'package:supabase_flutter/supabase_flutter.dart';

import '/models/categoria.dart';

class CategoriaService {
  static final SupabaseClient _client = Supabase.instance.client;

  Future<List<Categoria>> obterTodas() async {
    var registros = await _client.from('categories').select();
    return registros.map((json) => Categoria.fromJson(json)).toList();
  }

}