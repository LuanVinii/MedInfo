import 'package:supabase_flutter/supabase_flutter.dart';

import '/models/categoria.dart';

class CategoriaService {
  static final SupabaseQueryBuilder tabelaPadrao = Supabase.instance.client.from('categories');
  final SupabaseQueryBuilder tabela;

  CategoriaService({SupabaseQueryBuilder? tabela}) : tabela = tabela ?? tabelaPadrao;

  Future<List<Categoria>> getAll() async {
    final response = await tabela.select();
    return response.map((json) => Categoria.fromJson(json)).toList();
  }

}