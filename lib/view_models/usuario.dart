import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/medicamento.dart';
import '../models/usuario.dart';
import '../repositories/medicamento.dart';
import '../services/auth.dart';

enum UsuarioAcao {
  login,
  cadastro,
  logout,
  atualizarPerfil,
  favoritarMedicamento,
  desfavoritarMedicamento,
}

class UsuarioViewModel extends StateNotifier<UsuarioViewModelState> {
  UsuarioViewModel({AuthService? authService, MedicamentoRepository? medicamentoRepository})
      : _authService = authService ?? AuthService(),
        _medicamentoRepository = medicamentoRepository ?? MedicamentoRepository(),
        super(
          UsuarioViewModelState(
            usuario: (authService ?? AuthService()).currentUser,
          ),
        );

  final AuthService _authService;
  final MedicamentoRepository _medicamentoRepository;

  Future<void> login({
    required String email,
    required String senha,
  }) async {
    state = UsuarioViewModelState(
      usuario: state.usuario,
      estaCarregando: true,
    );

    try {
      final usuario = await _authService.login(email: email, password: senha);
      state = UsuarioViewModelState(
        usuario: usuario,
        estaCarregando: false,
        ultimaAcao: UsuarioAcao.login,
      );
    } catch (error) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        mensagemErro: _sanitizeError(error),
        ultimaAcao: UsuarioAcao.login,
      );
    }
  }

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    state = UsuarioViewModelState(
      usuario: state.usuario,
      estaCarregando: true,
    );

    try {
      final usuario = await _authService.cadastrar(
        nome: nome,
        email: email,
        password: senha,
      );
      state = UsuarioViewModelState(
        usuario: usuario,
        estaCarregando: false,
        ultimaAcao: UsuarioAcao.cadastro,
      );
    } catch (error) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        mensagemErro: _sanitizeError(error),
        ultimaAcao: UsuarioAcao.cadastro,
      );
    }
  }

  Future<void> logout() async {
    state = UsuarioViewModelState(
      usuario: state.usuario,
      estaCarregando: true,
    );

    try {
      await _authService.logout();
      state = UsuarioViewModelState(
        usuario: null,
        estaCarregando: false,
        ultimaAcao: UsuarioAcao.logout,
      );
    } catch (error) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        mensagemErro: _sanitizeError(error),
        ultimaAcao: UsuarioAcao.logout,
      );
    }
  }

  Future<void> atualizarPerfil({
    required String nome,
    required String email,
    String? novaSenha,
  }) async {
    state = UsuarioViewModelState(
      usuario: state.usuario,
      estaCarregando: true,
    );

    try {
      final usuario = await _authService.atualizarPerfil(
        nome: nome,
        email: email,
        novaSenha: novaSenha,
      );
      state = UsuarioViewModelState(
        usuario: usuario,
        estaCarregando: false,
        ultimaAcao: UsuarioAcao.atualizarPerfil,
      );
    } catch (error) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        mensagemErro: _sanitizeError(error),
        ultimaAcao: UsuarioAcao.atualizarPerfil,
      );
    }
  }

  Future<void> favoritarMedicamento(Medicamento medicamento) async {
    if (!state.estaAutenticado) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        mensagemErro: 'Você precisa estar logado para favoritar medicamentos',
        ultimaAcao: UsuarioAcao.favoritarMedicamento,
      );
      return;
    }

    state = UsuarioViewModelState(
      usuario: state.usuario,
      estaCarregando: true,
    );

    try {
      await _medicamentoRepository.salvarFavorito(state.usuario!.id, medicamento);
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        ultimaAcao: UsuarioAcao.favoritarMedicamento,
      );
    } catch (error) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        mensagemErro: _sanitizeError(error),
        ultimaAcao: UsuarioAcao.favoritarMedicamento,
      );
    }
  }

  Future<void> desfavoritarMedicamento(Medicamento medicamento) async {
    if (!state.estaAutenticado) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        mensagemErro: 'Você precisa estar logado para remover favoritos',
        ultimaAcao: UsuarioAcao.desfavoritarMedicamento,
      );
      return;
    }

    state = UsuarioViewModelState(
      usuario: state.usuario,
      estaCarregando: true,
    );

    try {
      await _medicamentoRepository.removerFavorito(state.usuario!.id, medicamento);
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        ultimaAcao: UsuarioAcao.desfavoritarMedicamento,
      );
    } catch (error) {
      state = UsuarioViewModelState(
        usuario: state.usuario,
        estaCarregando: false,
        mensagemErro: _sanitizeError(error),
        ultimaAcao: UsuarioAcao.desfavoritarMedicamento,
      );
    }
  }

  void limparFeedback() {
    state = UsuarioViewModelState(
      usuario: state.usuario,
    );
  }

  String _sanitizeError(Object error) {
    final rawMessage = error.toString();
    if (rawMessage.startsWith('Exception: ')) {
      return rawMessage.substring('Exception: '.length);
    }
    return rawMessage;
  }
}

class UsuarioViewModelState {
  final Usuario? usuario;
  final bool estaCarregando;
  final String? mensagemErro;
  final UsuarioAcao? ultimaAcao;

  const UsuarioViewModelState({
    this.usuario,
    this.estaCarregando = false,
    this.mensagemErro,
    this.ultimaAcao,
  });

  bool get estaAutenticado => usuario != null;
}

final usuarioViewModelProvider =
    StateNotifierProvider<UsuarioViewModel, UsuarioViewModelState>(
  (ref) => UsuarioViewModel(),
);

