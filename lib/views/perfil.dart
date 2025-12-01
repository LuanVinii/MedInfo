import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/view_models/usuario.dart';
import 'package:medinfo/widgets/globais.dart';

class PerfilView extends ConsumerStatefulWidget {
  const PerfilView({super.key});

  @override
  ConsumerState<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends ConsumerState<PerfilView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _alterarSenha = false;

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados atuais do usuário
    final usuario = ref.read(usuarioViewModelProvider).usuario;
    if (usuario != null) {
      _nomeController.text = usuario.nome;
      _emailController.text = usuario.email;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _handleAtualizarPerfil() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref.read(usuarioViewModelProvider.notifier).atualizarPerfil(
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          novaSenha: _alterarSenha ? _senhaController.text : null,
        );
  }

  void _mostrarSnack(String mensagem, Color corFundo, {Duration? duracao}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: corFundo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: duracao ?? const Duration(seconds: 3),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(
        prefixIcon,
        color: const Color(0xFF023542),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF023542),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UsuarioViewModelState>(usuarioViewModelProvider, (previous, next) {
      if (next.ultimaAcao != UsuarioAcao.atualizarPerfil || !mounted) {
        return;
      }

      if (next.mensagemErro != null) {
        _mostrarSnack(next.mensagemErro!, Colors.red.shade400);
      } else {
        _mostrarSnack(
          'Perfil atualizado com sucesso!',
          Colors.green.shade600,
        );
        // Limpa os campos de senha após sucesso
        _senhaController.clear();
        _confirmarSenhaController.clear();
        setState(() {
          _alterarSenha = false;
        });
      }

      ref.read(usuarioViewModelProvider.notifier).limparFeedback();
    });

    final usuarioState = ref.watch(usuarioViewModelProvider);
    final bool estaCarregando = usuarioState.estaCarregando;

    return AppScaffold(
      mainContent: [
        // Header
        Container(
          width: double.infinity,
          color: const Color(0xFF023542),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: const Text(
            'Meu Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Conteúdo
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Avatar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Ícone de perfil
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF023542).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF023542),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Campo de Nome
                      TextFormField(
                        controller: _nomeController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _buildInputDecoration(
                          labelText: 'Nome completo',
                          hintText: 'Seu nome',
                          prefixIcon: Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome';
                          }
                          if (value.length < 3) {
                            return 'Nome deve ter pelo menos 3 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Campo de Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          labelText: 'Email',
                          hintText: 'seu@email.com',
                          prefixIcon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Toggle para alterar senha
                      Row(
                        children: [
                          Checkbox(
                            value: _alterarSenha,
                            onChanged: (value) {
                              setState(() {
                                _alterarSenha = value ?? false;
                                if (!_alterarSenha) {
                                  _senhaController.clear();
                                  _confirmarSenhaController.clear();
                                }
                              });
                            },
                            activeColor: const Color(0xFF023542),
                          ),
                          const Text(
                            'Alterar senha',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF023542),
                            ),
                          ),
                        ],
                      ),

                      // Campos de senha (visíveis apenas se _alterarSenha for true)
                      if (_alterarSenha) ...[
                        const SizedBox(height: 16),

                        // Campo de Nova Senha
                        TextFormField(
                          controller: _senhaController,
                          obscureText: _obscurePassword,
                          decoration: _buildInputDecoration(
                            labelText: 'Nova senha',
                            hintText: 'Mínimo 6 caracteres',
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF023542),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (_alterarSenha) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira a nova senha';
                              }
                              if (value.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Campo de Confirmar Nova Senha
                        TextFormField(
                          controller: _confirmarSenhaController,
                          obscureText: _obscureConfirmPassword,
                          decoration: _buildInputDecoration(
                            labelText: 'Confirmar nova senha',
                            hintText: 'Digite a senha novamente',
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF023542),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (_alterarSenha) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, confirme a nova senha';
                              }
                              if (value != _senhaController.text) {
                                return 'As senhas não coincidem';
                              }
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 25),

                      // Botão de Salvar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: estaCarregando ? null : _handleAtualizarPerfil,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF023542),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          child: estaCarregando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Salvar Alterações',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

