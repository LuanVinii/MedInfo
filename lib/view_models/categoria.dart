import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/exceptions/base.dart';
import '/exceptions/globais.dart';
import '/models/categoria.dart';
import '/models/medicamento.dart';
import '/repositories/medicamento.dart';

class CategoriaViewModel extends StateNotifier<CategoriaViewModelState> {
  final Categoria categoria;
  final MedicamentoRepository _repository = MedicamentoRepository();

  CategoriaViewModel({required this.categoria}) : super(CategoriaViewModelState());

  Future<void> buscarMedicamentos(String termo) async {
    state = CategoriaViewModelState(estaCarregando: true);
    List<Medicamento>? medicamentos;
    AppException? erro;

    try {
      medicamentos = await _repository.buscarPorTermoNaCategoria(termo, categoria);
    } on SocketException {
      erro = InternetException();
    } on PostgrestException {
      erro = ServidorException();
    } on Exception {
      erro = ErroDesconhecidoException();
    }

    state = CategoriaViewModelState(medicamentos: medicamentos, erro: erro);
  }

  Future<void> obterMedicamentos() async {
    state = CategoriaViewModelState(estaCarregando: true);
    List<Medicamento>? medicamentos;
    AppException? erro;

    try {
      medicamentos = await _repository.obterPorCategoria(categoria);
    } on SocketException {
      erro = InternetException();
    } on PostgrestException {
      erro = ServidorException();
    } on Exception {
      erro = ErroDesconhecidoException();
    }

    state = CategoriaViewModelState(medicamentos: medicamentos, erro: erro);
  }

}

class CategoriaViewModelState {
  final bool estaCarregando;
  final List<Medicamento>? medicamentos;
  final AppException? erro;

  CategoriaViewModelState({
    this.estaCarregando = false,
    this.medicamentos,
    this.erro
  });
}

var categoriaViewModelProvider = StateNotifierProvider.family<CategoriaViewModel, CategoriaViewModelState, Categoria>(
    (ref, categoria) => CategoriaViewModel(categoria: categoria)
);