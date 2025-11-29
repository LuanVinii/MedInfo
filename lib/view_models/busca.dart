import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../exceptions/base.dart';
import '../exceptions/globais.dart';
import '../models/medicamento.dart';
import '../repositories/medicamento.dart';

class BuscaViewModel extends StateNotifier<BuscaViewModelState> {
  final MedicamentoRepository _repository = MedicamentoRepository();

  BuscaViewModel() : super(BuscaViewModelState());

  Future<void> buscarMedicamentos(String termo) async {
    state = BuscaViewModelState(estaCarregando: true, medicamentos: state.medicamentos);
    List<Medicamento> medicamentos = [];
    AppException? erro;

    try {
      medicamentos = await _repository.buscarPorTermo(termo);
    } on SocketException {
      erro = InternetException();
    } on PostgrestException {
      erro = ServidorException();
    } on Exception {
      erro = ErroDesconhecidoException();
    }

    state = BuscaViewModelState(medicamentos: medicamentos, erro: erro);
  }

}

class BuscaViewModelState {
  final bool estaCarregando;
  final List<Medicamento> medicamentos;
  final AppException? erro;

  BuscaViewModelState({
    this.estaCarregando = false,
    this.medicamentos = const [],
    this.erro
  });
}

var buscaViewModelProvider = StateNotifierProvider<BuscaViewModel, BuscaViewModelState>(
        (ref) => BuscaViewModel()
);