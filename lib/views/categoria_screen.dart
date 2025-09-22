import 'package:flutter/material.dart';
import 'package:medinfo/views/home_screen.dart';
import '../models/categoria.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CategoriaView',
      home: CategoriaScreen(),
    );
  }
}

class CategoriaScreen extends StatelessWidget {
  CategoriaScreen({super.key});

  final List<Categoria> _categorias = [
    Categoria(
      id: 1,
      nome: 'Antigripais',
      descricao: 'Alívio de sintomas de gripe',
      icone: 'antigripais',
    ),
    Categoria(
      id: 2,
      nome: 'Analgésico',
      descricao: 'Para dor e desconforto',
      icone: 'analgesico',
    ),
    Categoria(
      id: 3,
      nome: 'Antialérgicos',
      descricao: 'Controle de reações alérgicas',
      icone: 'antialergicos',
    ),
    Categoria(
      id: 4,
      nome: 'Anti-inflamatório',
      descricao: 'Reduz inflamação e dor',
      icone: 'antiinflamatorio',
    ),
    Categoria(
      id: 5,
      nome: 'Antibiótico',
      descricao: 'Combate infecções',
      icone: 'antibiotico',
    ),
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'antigripais':
        return Icons.sick; // gripe/doença
      case 'analgesico':
        return Icons.healing; // cura/remédio
      case 'antialergicos':
        return Icons.local_hospital; // hospital/alergia
      case 'antiinflamatorio':
        return Icons.medical_services; // inflamação/serviço médico
      case 'antibiotico':
        return Icons.vaccines; // antibiótico/vacina
      default:
        return Icons.medical_services; // padrão
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: Column(
              children: [
                const TopBar(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF023542),
                  child: const Center(
                    child: Text(
                      "Categoria",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = _categorias[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF023542),
                            child: Text(
                              categoria.nome[0],
                              style: const TextStyle(color: Colors.white),
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
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Icon(
                            _getIconData(categoria.icone),
                            color: const Color(0xFF023542),
                            size: 28,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Abrindo medicamentos de ${categoria.nome}'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
