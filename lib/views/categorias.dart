import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categoria.dart';
import '../view_models/categorias.dart';
import '../widgets/globais.dart';

// Cor padrão do projeto (azul petróleo). Mantemos como const para evitar repetição.
const Color _primaryColor = Color(0xFF023542);

final _allMedicalIcons = [
  Icons.medication_liquid,
  Icons.medication,
  Icons.local_hospital,
  Icons.medical_services,
  Icons.vaccines,
  Icons.health_and_safety,
  Icons.healing,
  Icons.medical_information,
  Icons.sick,
  Icons.coronavirus,
  Icons.airline_seat_flat,
  Icons.monitor_heart,
  Icons.biotech,
  Icons.science,
  Icons.psychology,
  Icons.thermostat,
  Icons.water_drop,
  Icons.masks,
];

class CategoriasView extends ConsumerWidget {
  const CategoriasView({super.key});

  IconData _getRandomIconData(String iconName) => _allMedicalIcons[Random().nextInt(_allMedicalIcons.length)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CategoriasViewModelState state = ref.watch(categoriasViewModelProvider);

    return Column(
      children: [
        // Barra superior reutilizável (menu, logo, perfil)
        UserAppBar(),

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

        // CORREÇÃO: Expanded envolvendo a ListView
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(), // Rolagem mais suave
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            itemCount: state.categorias.length,
            itemBuilder: (context, index) {
              final categoria = state.categorias[index];
              return CategoryCard(
                categoria: categoria,
                iconData: _getRandomIconData(categoria.icone),
              );
            },
          ),
        ),
      ],
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