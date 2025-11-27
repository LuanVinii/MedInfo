import 'package:flutter/material.dart';
import 'package:medinfo/widgets/globais.dart';

import '../services/auth.dart';
import 'login.dart';

class AjustesView extends StatelessWidget {
  const AjustesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar customizada
        const UserAppBar(),

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
        Expanded(
          child: Padding(
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
                  onPressed: () async {
                    // Importar o serviço de auth
                    final authService = AuthService();

                    try {
                      await authService.logout();

                      // Navegar para a tela de login
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                              (route) => false,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao fazer logout: $e'),
                            backgroundColor: Colors.red[400],
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
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
        ),
      ],
    );
  }
}