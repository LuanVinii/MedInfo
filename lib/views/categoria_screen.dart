import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoriaScreen extends StatelessWidget {
  // REMOVER O 'const' DO CONSTRUTOR
  CategoriaScreen({Key? key}) : super(key: key);

  // Lista de categorias (agora funciona porque o construtor não é mais const)
  final List<Categoria> _categorias = [
    Categoria(
      id: 1,
      nome: 'Antigripais',
      descricao: 'Alívio de sintomas de gripeR',
      icone: 'sick_outlined',
    ),
    Categoria(
      id: 2,
      nome: 'Analgésicos',
      descricao: 'Para dor e desconforto',
      icone: 'medication_outlined',
    ),
    Categoria(
      id: 3,
      nome: 'Antialérgicos',
      descricao: 'Controle de reações alérgicas',
      icone: 'nature_outlined',
    ),
    Categoria(
      id: 4,
      nome: 'Anti-inflamatórios',
      descricao: 'Reduz inflamação e dor',
      icone: 'local_fire_department_outlined',
    ),
    Categoria(
      id: 5,
      nome: 'Antibióticos',
      descricao: 'Combate infecções',
      icone: 'health_and_safety_outlined',
    ),
  ];

  // Método para converter string em IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sick_outlined':
        return Icons.sick_outlined;
      case 'medication_outlined':
        return Icons.medication_outlined;
      case 'nature_outlined':
        return Icons.nature_outlined;
      case 'local_fire_department_outlined':
        return Icons.local_fire_department_outlined;
      case 'health_and_safety_outlined':
        return Icons.health_and_safety_outlined;
      default:
        return Icons.medication_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'MedInfo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue, Colors.purple],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Categoria',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final categoria = _categorias[index];
                return _buildItemCategoria(categoria, context);
              },
              childCount: _categorias.length,
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categoria',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          // Navegação será implementada depois
        },
      ),
    );
  }

  Widget _buildItemCategoria(Categoria categoria, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            _getIconData(categoria.icone),
            color: Colors.blue.shade800,
          ),
        ),
        title: Text(
          categoria.nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          categoria.descricao,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _navegarParaMedicamentos(categoria, context);
        },
      ),
    );
  }

  void _navegarParaMedicamentos(Categoria categoria, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegar para medicamentos de ${categoria.nome}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}