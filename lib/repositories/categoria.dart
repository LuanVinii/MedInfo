import '/models/categoria.dart';
import '/services/categoria.dart';

class CategoriaRepository {
  final CategoriaService service;

  CategoriaRepository({CategoriaService? service}) : service = service ?? CategoriaService();

  Future<List<Categoria>> obterTodas() async {
    return await service.obterTodas();
  }

}