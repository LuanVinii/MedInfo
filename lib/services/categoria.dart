import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/models/categoria.dart';

class CategoriaService {
  static final SupabaseClient _client = Supabase.instance.client;

  Future<List<Categoria>> obterTodas() async {
    debugPrint('🔍 Buscando categorias do Supabase...');
    var registros = await _client.from('categories').select();
    debugPrint('📦 Registros recebidos: ${registros.length}');
    debugPrint('📋 Dados: $registros');
    
    final categorias = registros.map((json) => Categoria.fromJson(json)).toList();
    debugPrint('✅ Categorias convertidas: ${categorias.length}');
    return categorias;
  }

}