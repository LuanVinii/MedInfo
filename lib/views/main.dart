import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/views/ajustes.dart';
import '/views/bookmarks.dart';
import '/views/categorias.dart';
import '/views/home.dart';
import '/widgets/globais.dart';

List<Widget> _views = [
  HomeView(),
  CategoriasView(),
  BookmarksView(),
  AjustesView()
];

class MainAppView extends ConsumerStatefulWidget {
  const MainAppView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppViewState();

}

class _MainAppViewState extends ConsumerState<MainAppView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(child: Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _currentIndex, children: _views),
      bottomNavigationBar: Footer(currentIndex: _currentIndex, onTapIndex: _updateIndexOnTap)
    ));
  }

  void _updateIndexOnTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}

class FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  const FooterItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Muda a cor dependendo se está selecionado ou não
    final color = selected ? Colors.white : Colors.white70;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

//
// Barra inferior inteira. Controla os botões e repassa o índice selecionado.
//
class Footer extends StatelessWidget {
  final Function(int) onTapIndex;
  final int currentIndex;

  const Footer({required this.onTapIndex, required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF023542),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FooterItem(
            icon: Icons.home,
            label: 'Início',
            selected: currentIndex == 0,
            onTap: () => onTapIndex(0),
          ),
          FooterItem(
            icon: Icons.medical_services,
            label: 'Categorias',
            selected: currentIndex == 1,
            onTap: () => onTapIndex(1),
          ),
          FooterItem(
            icon: Icons.bookmark,
            label: 'Medicamentos',
            selected: currentIndex == 2,
            onTap: () => onTapIndex(2),
          ),
          FooterItem(
            icon: Icons.settings,
            label: 'Configurações',
            selected: currentIndex == 3,
            onTap: () => onTapIndex(3),
          ),
        ],
      ),
    );
  }
}