import 'package:flutter/material.dart';
import 'package:medinfo/views/home_screen.dart';
import 'package:medinfo/views/categoria_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedInfo',
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    CategoriaScreen(),
    const AjustePage(),
  ];

  void _onFooterTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTapIndex: _onFooterTap,
      ),
    );
  }
}

// Footer customizado
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
            icon: Icons.category,
            label: 'Categoria',
            selected: currentIndex == 1,
            onTap: () => onTapIndex(1),
          ),
          FooterItem(
            icon: Icons.settings,
            label: 'Ajuste',
            selected: currentIndex == 2,
            onTap: () => onTapIndex(2),
          ),
        ],
      ),
    );
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

// AjustePage para a terceira opção do Footer
class AjustePage extends StatelessWidget {
  const AjustePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: const Color(0xFF023542),
      ),
      body: const Center(
        child: Text('Página de Ajustes', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
