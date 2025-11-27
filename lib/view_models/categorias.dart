import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/exceptions/base.dart';
import '/exceptions/globais.dart';
import '/models/categoria.dart';
import '/repositories/categoria.dart';

class CategoriasViewModel extends StateNotifier<CategoriasViewModelState> {
  final CategoriaRepository _repository = CategoriaRepository();

  CategoriasViewModel() : super(CategoriasViewModelState());

  Future<void> obterTodas() async {
    state = CategoriasViewModelState(estaCarregando: true);
    List<Categoria> categorias = [];
    AppException? erro;

    try {
      categorias = await _repository.obterTodas();
    } on SocketException {
      erro = InternetException();
    } on PostgrestException {
      erro = ServidorException();
    } on Exception {
      erro = ErroDesconhecidoException();
    }

    state = CategoriasViewModelState(categorias: categorias, erro: erro);
  }
}

class CategoriasViewModelState {
  final bool estaCarregando;
  final List<Categoria> categorias;
  final AppException? erro;

  CategoriasViewModelState({
    this.estaCarregando = false,
    this.categorias = const [],
    this.erro
  });
}

var categoriasViewModelProvider = StateNotifierProvider<CategoriasViewModel, CategoriasViewModelState>(
    (ref) => CategoriasViewModel()
);