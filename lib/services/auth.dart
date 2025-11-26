import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario.dart';

/// Serviço de autenticação usando **apenas** a tabela `users` do banco.
///
/// Não usa o módulo de autenticação do Supabase, apenas a conexão
/// com o banco de dados para ler/escrever na tabela `users`.
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Usuario? _currentUser;

  /// Usuário atual em memória (apenas enquanto o app está aberto).
  Usuario? get currentUser => _currentUser;

  /// Indica se existe um usuário logado em memória.
  bool get isAuthenticated => _currentUser != null;

  /// Realiza o login buscando na tabela `users` pelo par (email, password).
  ///
  /// Lança [Exception] com mensagem amigável em caso de erro.
  Future<Usuario> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password)
          .maybeSingle();

      if (data == null) {
        throw Exception('Email ou senha incorretos');
      }

      _currentUser = Usuario.fromJson(Map<String, dynamic>.from(data));
      return _currentUser!;
    } on PostgrestException catch (e) {
      throw Exception('Erro no banco de dados: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  /// Realiza o cadastro inserindo um novo registro na tabela `users`.
  ///
  /// - Verifica primeiro se já existe usuário com o mesmo email.
  /// - Em seguida insere name/email/password.
  Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String password,
  }) async {
    try {
      // Verifica se já existe usuário com esse email
      final existing = await _supabase
          .from('users')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Este email já está cadastrado');
      }

      // Insere novo usuário e retorna o registro criado
      final inserted = await _supabase
          .from('users')
          .insert({
            'name': nome,
            'email': email,
            'password': password,
          })
          .select()
          .single();

      _currentUser = Usuario.fromJson(Map<String, dynamic>.from(inserted));
      return _currentUser!;
    } on PostgrestException catch (e) {
      throw Exception('Erro ao criar conta: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao criar conta: $e');
    }
  }

  /// "Logout" simples: apenas limpa o usuário em memória.
  Future<void> logout() async {
    _currentUser = null;
  }

  /// Como estamos usando apenas a tabela `users` e não o módulo de Auth
  /// do Supabase, não há envio automático de email de recuperação de senha.
  ///
  /// Aqui apenas lançamos uma exceção explicando a limitação.
  Future<void> recuperarSenha(String email) async {
    throw Exception(
      'Recuperação de senha ainda não está disponível neste modo de autenticação.',
    );
  }
}

