import 'package:flutter/material.dart';
import '../../widgets/global_background.dart';
import '../../widgets/shared_widgets.dart'; // Footer e AjustePage
import 'home_screen.dart';
import 'categoria_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  // Lista de telas usadas no menu inferior
  final List<Widget> _pages = [
    const HomeView(),       // Tela inicial
    CategoriaScreen(),      // Tela de categorias
    const AjustePage(),     // Tela de ajustes
  ];

  // Atualiza o índice da tela selecionada no footer
  void _onFooterTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usa o GlobalBackground para aplicar o fundo em toda a estrutura
    return GlobalBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // Mantém o fundo visível

        // IndexedStack mantém o estado das telas ao alternar
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        
        // Barra de navegação inferior
        bottomNavigationBar: Footer(
          currentIndex: _currentIndex,
          onTapIndex: _onFooterTap,
        ),
      ),
    );
  }
}

// Tela simples usada quando alguma página ainda não existe
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    // Container transparente para manter o fundo global visível
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Text(
          'Tela de $title',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
