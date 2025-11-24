import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  final Widget child; 
  // Este "child" é o conteúdo que vai aparecer por cima do background

  const GlobalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Camada 1 — fundo branco, só para garantir que nunca fique tela preta.
        Container(color: Colors.white),

        // Camada 2 — imagem de fundo com leve transparência.
        // Ela preenche a tela inteira.
        Positioned.fill(
          child: Opacity(
            opacity: 0.27, // Isso deixa a imagem mais suave (quase um "fundo d'água")
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover, // A imagem sempre cobre toda a área
            ),
          ),
        ),

        // Camada 3 — conteúdo real da tela (telas Home, Categoria etc.)
        // Fica por cima do background.
        child,
      ],
    );
  }
}
