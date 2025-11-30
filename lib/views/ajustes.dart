import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/view_models/usuario.dart';
import 'package:medinfo/widgets/globais.dart';

import 'login.dart';

class AjustesView extends ConsumerWidget {
  const AjustesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UsuarioViewModelState>(usuarioViewModelProvider, (previous, next) {
      if (next.ultimaAcao != UsuarioAcao.logout) {
        return;
      }

      if (!context.mounted) {
        return;
      }

      if (next.mensagemErro != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer logout: ${next.mensagemErro}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const LoginView(),
          ),
          (route) => false,
        );
      }

      ref.read(usuarioViewModelProvider.notifier).limparFeedback();
    });

    final usuarioState = ref.watch(usuarioViewModelProvider);

    return AppScaffold(
      mainContent: [
        // Header
        Container(
          width: double.infinity,
          color: const Color(0xFF023542),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: const Text(
            'Ajustes',
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
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Card de perfil
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
                    const Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Color(0xFF023542),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Configurações',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF023542),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botão de logout
              ElevatedButton.icon(
                onPressed: usuarioState.estaCarregando
                    ? null
                    : () => ref.read(usuarioViewModelProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
                label: usuarioState.estaCarregando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Sair',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}