import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço de autenticação usando Supabase
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Retorna o cliente Supabase
  SupabaseClient get client => _supabase;

  /// Retorna o usuário atual logado
  User? get currentUser => _supabase.auth.currentUser;

  /// Verifica se existe um usuário logado
  bool get isAuthenticated => currentUser != null;

  /// Realiza o login com email e senha
  /// 
  /// Retorna o usuário autenticado em caso de sucesso
  /// Lança uma exceção em caso de erro
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response.user;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  /// Realiza o cadastro de um novo usuário
  /// 
  /// Retorna o usuário criado em caso de sucesso
  /// Lança uma exceção em caso de erro
  Future<User?> cadastrar({
    required String nome,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': nome,
        },
      );

      return response.user;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao criar conta: $e');
    }
  }

  /// Realiza o logout do usuário
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  /// Envia email de recuperação de senha
  Future<void> recuperarSenha(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erro ao enviar email de recuperação: $e');
    }
  }

  /// Stream que monitora mudanças no estado de autenticação
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Traduz exceções do Supabase para mensagens em português
  String _handleAuthException(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return 'Email ou senha incorretos';
      case 'Email not confirmed':
        return 'Email não confirmado. Verifique sua caixa de entrada';
      case 'User already registered':
        return 'Este email já está cadastrado';
      case 'Password should be at least 6 characters':
        return 'A senha deve ter pelo menos 6 caracteres';
      case 'Invalid email':
        return 'Email inválido';
      case 'Email rate limit exceeded':
        return 'Muitas tentativas. Tente novamente mais tarde';
      default:
        return e.message;
    }
  }
}

