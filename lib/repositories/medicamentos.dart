import '/models/categoria.dart';
import '/models/medicamento.dart';
import '/models/usuario.dart';
import '/services/medicamento.dart';

class MedicamentoRepository {
  final MedicamentoService service;

  MedicamentoRepository(MedicamentoService? service) : service = service ?? MedicamentoService();

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
    return await service.obterPorUsuario(usuario);
  }

}