import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  bool _isInitialized = false;

  static const String _prefsUserKey = 'medinfo_current_user';

  factory AuthService() => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<void> init() async {
    if (_isInitialized) return;
    await _restorePersistedUser();
    _isInitialized = true;
  }

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
      await _persistUser(_currentUser!);
      return _currentUser!;
    } on PostgrestException catch (e) {
      throw Exception('Erro no banco de dados: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

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
      await _persistUser(_currentUser!);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsUserKey);
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

  Future<void> _persistUser(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsUserKey,
      jsonEncode({
        'id': usuario.id,
        'name': usuario.nome,
        'email': usuario.email,
        'password': usuario.senha,
      }),
    );
  }

  Future<void> _restorePersistedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsUserKey);
    if (raw == null) return;

    try {
      final Map<String, dynamic> data = jsonDecode(raw);
      _currentUser = Usuario.fromJson(data);
    } catch (_) {
      await prefs.remove(_prefsUserKey);
      _currentUser = null;
    }
  }
}

