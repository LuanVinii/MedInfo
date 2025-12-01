import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/models/medicamento.dart';
import 'package:medinfo/models/usuario.dart';
import 'package:medinfo/repositories/medicamento.dart';
import 'package:medinfo/view_models/usuario.dart';

class BookmarksViewModelState {
  final List<Medicamento> medicamentosSalvos;
  final bool estaCarregando;
  final String? mensagemErro;

  BookmarksViewModelState({
    this.medicamentosSalvos = const [],
    this.estaCarregando = false,
    this.mensagemErro,
  });

  BookmarksViewModelState copyWith({
    List<Medicamento>? medicamentosSalvos,
    bool? estaCarregando,
    String? mensagemErro,
  }) {
    return BookmarksViewModelState(
      medicamentosSalvos: medicamentosSalvos ?? this.medicamentosSalvos,
      estaCarregando: estaCarregando ?? this.estaCarregando,
      mensagemErro: mensagemErro,
    );
  }
}

class BookmarksViewModel extends StateNotifier<BookmarksViewModelState> {
  final MedicamentoRepository _repository;
  final Ref _ref;

  BookmarksViewModel(this._ref, {MedicamentoRepository? repository}) 
      : _repository = repository ?? MedicamentoRepository(),
        super(BookmarksViewModelState()) {

        _ref.listen<UsuarioViewModelState>(usuarioViewModelProvider, (_, newState) {
            obterMedicamentosSalvos();
        }, fireImmediately: true);
    }

  Future<void> obterMedicamentosSalvos() async {
    final usuarioState = _ref.read(usuarioViewModelProvider);

    if (!usuarioState.estaAutenticado) {
      state = BookmarksViewModelState(medicamentosSalvos: const [], estaCarregando: false, mensagemErro: null);
      return;
    }

    state = state.copyWith(estaCarregando: true, mensagemErro: null);
    
    try {
      final medicamentos = await _repository.obterPorUsuario(usuarioState.usuario!); 
      
      state = state.copyWith(
        medicamentosSalvos: medicamentos,
        estaCarregando: false,
      );
    } catch (e) {
      state = state.copyWith(
        estaCarregando: false,
        mensagemErro: "Falha ao carregar favoritos: $e",
      );
    }
  }
  
  bool isSalvo(Medicamento medicamento) {
    return state.medicamentosSalvos.any((m) => m.id == medicamento.id);
  }
}

final bookmarksViewModelProvider = StateNotifierProvider<BookmarksViewModel, BookmarksViewModelState>(
  (ref) => BookmarksViewModel(ref)
);