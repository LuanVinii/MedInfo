import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/models/categoria.dart';
import 'package:medinfo/view_models/busca.dart';
import 'package:medinfo/view_models/categorias.dart';
import 'package:medinfo/view_models/navigation.dart';
import 'package:medinfo/views/busca.dart';
import 'package:medinfo/views/categoria.dart';

import '/widgets/globais.dart';

final List<IconData> medicamentoIcons = [
  Icons.medication,
  Icons.medication_liquid,
  Icons.local_hospital,
  Icons.medical_services,
  Icons.vaccines,
  Icons.local_pharmacy,
  Icons.healing,
  Icons.science,
  Icons.biotech,
  Icons.bloodtype,
  Icons.monitor_heart,
  Icons.egg,           // para cápsulas
  Icons.circle,        // para comprimidos
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Flag que indica se o usuário já clicou no botão "Entendi"
  // Serve para mudar o botão para um check verde depois
  bool _disclaimerAcknowledged = false;

  // Função chamada quando o usuário aperta "Entendi"
  void _acknowledgeDisclaimer() {
    setState(() {
      _disclaimerAcknowledged = true;
    });
    // Aqui depois você pode salvar no SharedPreferences para lembrar entre sessões
  }

  Widget _paddedDisclaimerBox() => Container(
    padding: EdgeInsets.all(16.0),
    child: DisclaimerBox(
      isAcknowledged: _disclaimerAcknowledged,
      onAcknowledge: _acknowledgeDisclaimer,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(mainContent: [
      HeaderSection(),
      SizedBox(height: 10),
      SingleChildScrollView(child: _paddedDisclaimerBox())
    ]);
  }

}


/// ----------------------------
///  WIDGET: Caixa de Aviso
/// ----------------------------
///
/// Widget único que exibe:
/// - Título "Atenção!"
/// - Texto explicando que não substitui orientação médica
/// - Botão para saber mais
/// - Botão "Entendi" que vira um check verde depois
///
class DisclaimerBox extends StatelessWidget {
  final VoidCallback onAcknowledge; // Função chamada quando clicam no botão
  final bool isAcknowledged;        // Indica se já marcaram como lido

  const DisclaimerBox({
    required this.onAcknowledge,
    required this.isAcknowledged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Área da caixa
      padding: const EdgeInsets.all(20),

      // Aparência visual do card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          // Sombra suave para destacar do fundo
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),

      // Conteúdo interno
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Título grande da caixa
          const Text(
            "Atenção!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF023542),
            ),
          ),

          const SizedBox(height: 15),

          // Texto explicando a função do app
          const Text(
            "As informações apresentadas neste aplicativo são reunidas de fontes públicas da internet e têm apenas o objetivo de organizar dados sobre medicamentos em um só lugar.\n\n"
                "Elas não substituem consulta médica, diagnóstico profissional ou orientação de um farmacêutico.",
            style: TextStyle(
              fontSize: 15,
              height: 1.4, // Deixa o texto mais confortável de ler
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),

          const SizedBox(height: 25),

          // Linha com os dois botões da caixa
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              // Botão "Entendi"
              ElevatedButton(
                onPressed: isAcknowledged ? null : onAcknowledge,
                // Se já clicou antes, o botão fica desativado

                style: ElevatedButton.styleFrom(
                  // Cor muda se já foi reconhecido
                  backgroundColor: isAcknowledged
                      ? Colors.green
                      : const Color(0xFF023542),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),

                // Conteúdo do botão
                child: isAcknowledged
                // Se já clicou: aparece só um ícone de check
                    ? const Icon(Icons.check, size: 24)
                // Se ainda não clicou: mostra "Entendi"
                    : const Text(
                  "Entendi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CompactCategories extends ConsumerWidget {
  const CompactCategories({super.key});

  List<Categoria> _getRandomCategories(List<Categoria> categories) {
    if (categories.isEmpty) {
      return [];
    }

    // Cria uma cópia para não modificar a lista original
    List<Categoria> shuffledCategories = List.from(categories);

    // Embaralha as categorias
    shuffledCategories.shuffle();

    // Pega no máximo 3 categorias aleatórias
    return shuffledCategories.take(3).toList();
  }

  List<IconData> _getRandomIcons(int count) {
    if (count == 0) return [];

    // Cria uma cópia da lista de ícones
    List<IconData> shuffledIcons = List.from(medicamentoIcons);

    // Embaralha os ícones
    shuffledIcons.shuffle();

    // Pega a quantidade necessária de ícones aleatórios
    return shuffledIcons.take(count).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriasViewModelProvider);

    // Estado de carregamento
    if (categoriesState.estaCarregando) {
      return _buildLoadingState();
    }

    // Estado de erro
    if (categoriesState.erro != null) {
      return _buildErrorState(categoriesState.erro!.mensagem);
    }

    final mainCategories = _getRandomCategories(categoriesState.categorias);

    // Estado vazio
    if (mainCategories.isEmpty) {
      return _buildEmptyState();
    }

    final mainIcons = _getRandomIcons(mainCategories.length);

    return _buildCategoriesRow(mainCategories, mainIcons);
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox.shrink();
  }

  Widget _buildCategoriesRow(List<Categoria> categories, List<IconData> icons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(categories.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? 8 : 0,
            ),
            child: _CategoryChip(
              category: categories[index],
              icon: icons[index],
            ),
          ),
        );
      }),
    );
  }
}


class HeaderSection extends ConsumerStatefulWidget {
  const HeaderSection({super.key});

  @override
  ConsumerState<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<HeaderSection> {
  final TextEditingController _searchController = TextEditingController();

  void _navigateToSearch() {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      ref.read(buscaViewModelProvider.notifier).buscarMedicamentos(searchText);
      ref.read(navigationViewModelProvider.notifier).changeView(
        BuscaView(term: searchText),
        context,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF023542),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          // Campo de pesquisa
          TextField(
            controller: _searchController,
            onSubmitted: (_) => _navigateToSearch(),
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                color: const Color(0xFF023542),
                onPressed: _navigateToSearch,
              ),
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          CompactCategories()

        ],
      ),
    );
  }
}

class _CategoryChip extends ConsumerStatefulWidget {
  final Categoria category;
  final IconData icon;

  const _CategoryChip({
    required this.category,
    required this.icon,
  });

  @override
  ConsumerState<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends ConsumerState<_CategoryChip>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ref.read(navigationViewModelProvider.notifier).changeView(CategoriaView(categoria: widget.category), context),
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),

      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.black87, size: 16),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  widget.category.nome,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}