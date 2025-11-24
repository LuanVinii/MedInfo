import 'package:flutter/material.dart';
import '../models/categoria.dart';
// Este arquivo não usa o GlobalBackground diretamente porque isso é feito no AppShell
import '../widgets/shared_widgets.dart';

// Cor padrão do projeto (azul petróleo). Mantemos como const para evitar repetição.
const Color _primaryColor = Color(0xFF023542);

class CategoriaScreen extends StatelessWidget {
  CategoriaScreen({super.key});

  // Lista fixa de categorias exibidas na tela.
  // Cada item tem id, nome, descrição e um identificador de ícone.
  // Isso mantém a tela limpa e evita código repetido.
  final List<Categoria> _categorias = [
    Categoria(id: 1, nome: 'Antigripais', descricao: 'Alívio de sintomas de gripe', icone: 'antigripais'),
    Categoria(id: 2, nome: 'Analgésico', descricao: 'Para dor e desconforto', icone: 'analgesico'),
    Categoria(id: 3, nome: 'Antialérgicos', descricao: 'Controle de reações alérgicas', icone: 'antialergicos'),
    Categoria(id: 4, nome: 'Anti-inflamatório', descricao: 'Reduz inflamação e dor', icone: 'antiinflamatorio'),
    Categoria(id: 5, nome: 'Antibiótico', descricao: 'Combate infecções', icone: 'antibiotico'),
  ];

  // Função que converte o nome do ícone (string) para um ícone real do Flutter.
  // Isso reúne toda a lógica de ícones em um lugar só e evita vários if/else na interface.
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'antigripais': return Icons.medication_liquid;
      case 'analgesico': return Icons.medication;
      case 'antialergicos': return Icons.local_hospital;
      case 'antiinflamatorio': return Icons.medical_services;
      case 'antibiotico': return Icons.vaccines;
      default: return Icons.medical_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Deixamos transparente para que o background geral apareça por trás
      backgroundColor: Colors.transparent,

      // Toda a estrutura da tela fica dentro de um Column
      body: Column(
        children: [
          // Barra superior reutilizável (menu, logo, perfil)
          const CustomAppBar(),

          // Cabeçalho da página com o título
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: _primaryColor,
            child: const Text(
              "Categoria",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Lista das categorias com rolagem
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(), // Rolagem mais suave
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                return CategoryCard(
                  categoria: categoria,
                  iconData: _getIconData(categoria.icone),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Categoria categoria;
  final IconData iconData;

  const CategoryCard({
    required this.categoria,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Distância horizontal e vertical entre os cards
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // Material fornece sombra, bordas e aspecto de "card"
      child: Material(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.12),

        // Borda discreta que deixa o card mais definido
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),

        child: InkWell(
          // Animação de toque do Material (splash)
          borderRadius: BorderRadius.circular(12),
          splashColor: _primaryColor.withOpacity(0.15),
          highlightColor: Colors.transparent,

          onTap: () {
            // Aqui vai a navegação para os medicamentos da categoria no futuro
          },

          child: Row(
            children: [
              // Avatar circular com a primeira letra da categoria
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: _primaryColor,
                  child: Text(
                    categoria.nome[0], // Primeira letra do nome
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              // Nome e descrição da categoria
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoria.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categoria.descricao,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ícone do lado direito com fundo azul
              // ClipRRect garante que as bordas sigam o mesmo arredondamento do card
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Container(
                  width: 70,
                  constraints: const BoxConstraints(minHeight: 95),
                  decoration: const BoxDecoration(
                    color: _primaryColor,
                  ),
                  child: Icon(
                    iconData,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
