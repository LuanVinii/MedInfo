import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/view_models/busca.dart';
import 'package:medinfo/view_models/navigation.dart';
import 'package:medinfo/views/medicamento.dart';
import 'package:medinfo/widgets/globais.dart';

import '../models/medicamento.dart';

class BuscaView extends ConsumerWidget {
  String term;
  BuscaView({super.key, this.term = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var buscaState = ref.watch(buscaViewModelProvider);
    return AppScaffold(
      scrollable: false,

      mainContent: [
        SearchingBar(),
        buscaState.estaCarregando? loadingIndicator() : SizedBox.shrink(),
        Expanded(child: _ResultView()),
    ]);
  }

}

class SearchingBar extends ConsumerStatefulWidget {
  const SearchingBar({super.key});

  @override
  ConsumerState<SearchingBar> createState() => _SearchingBarState();
}

class _SearchingBarState extends ConsumerState<SearchingBar> {
  final TextEditingController _controller = TextEditingController();
  String _currentTerm = '';

  void _performSearch() {
    final term = _controller.text.trim();
    if (term.isNotEmpty && term != _currentTerm) {
      _currentTerm = term;
      ref.read(buscaViewModelProvider.notifier).buscarMedicamentos(term);
    }
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _currentTerm = '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF023542),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: TextField(
        controller: _controller,
        onSubmitted: (_) => _performSearch(), // ← Busca ao pressionar Enter
        decoration: InputDecoration(
          hintText: 'Pesquisar...',
          suffixIcon: _buildSuffixIcon(),
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
    );
  }

  Widget _buildSuffixIcon() {
    if (_currentTerm.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botão de limpar
          IconButton(
            icon: const Icon(Icons.clear, size: 20),
            color: const Color(0xFF023542),
            onPressed: _clearSearch,
          ),
          // Botão de buscar
          IconButton(
            icon: const Icon(Icons.search, size: 20),
            color: const Color(0xFF023542),
            onPressed: _performSearch, // ← Busca ao clicar no ícone
          ),
        ],
      );
    } else {
      // Apenas ícone de busca quando vazio
      return IconButton(
        icon: const Icon(Icons.search),
        color: const Color(0xFF023542),
        onPressed: _performSearch, // ← Busca ao clicar no ícone
      );
    }
  }
}

class _ResultView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicamentos = ref.watch(buscaViewModelProvider).medicamentos;

    if (medicamentos.isEmpty) {
      return _notFoundView();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80), // Espaço para navigation bar
      itemCount: medicamentos.length,
      itemBuilder: (context, index) {
        final medicamento = medicamentos[index];
        return _ResultCard(
          medicamento: medicamento,
        );
      },
    );
  }

  Widget _notFoundView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Nenhum medicamento encontrado!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class _ResultCard extends ConsumerWidget { // ← Mudou para ConsumerWidget
  final Medicamento medicamento;

  const _ResultCard({required this.medicamento});

  void _navigateToMedicamentoView(BuildContext context, WidgetRef ref) {
    ref.read(navigationViewModelProvider.notifier).changeView(
      MedicamentoView(medicamento: medicamento),
      context,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToMedicamentoView(context, ref), // ← Navegação no tap
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                _getTarjaColor(medicamento.tarja.nome).withOpacity(0.05),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 400;
              return isCompact ? _buildCompactLayout() : _buildNormalLayout();
            },
          ),
        ),
      ),
    );
  }

  // Layout para telas normais (> 400px)
  Widget _buildNormalLayout() {
    return Row(
      children: [
        // Ícone médico + tarja
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _getTarjaColor(medicamento.tarja.nome).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getTarjaColor(medicamento.tarja.nome).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getMedicationIcon(medicamento.formato.descricao),
                color: _getTarjaColor(medicamento.tarja.nome),
                size: 24,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTarjaColor(medicamento.tarja.nome),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTarjaAbbreviation(medicamento.tarja.nome),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Informações principais
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicamento.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF023542),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Laboratório
              Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 12,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      medicamento.laboratorio.nome,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Formato e Via
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4F8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      medicamento.formato.descricao,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF023542),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      medicamento.viaAdministracao.descricao,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Preço e ação
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF023542),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatPrice(medicamento.precoMedio),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF023542).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: const Color(0xFF023542),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Layout para telas pequenas (< 400px)
  Widget _buildCompactLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho com ícone e nome
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getTarjaColor(medicamento.tarja.nome).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getTarjaColor(medicamento.tarja.nome).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getMedicationIcon(medicamento.formato.descricao),
                    color: _getTarjaColor(medicamento.tarja.nome),
                    size: 20,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: _getTarjaColor(medicamento.tarja.nome),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getTarjaAbbreviation(medicamento.tarja.nome),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicamento.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF023542),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    medicamento.laboratorio.nome,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Informações secundárias
        Row(
          children: [
            // Formato e Via
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4F8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      medicamento.formato.descricao,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF023542),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      medicamento.viaAdministracao.descricao,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Preço e ação
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF023542),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _formatPrice(medicamento.precoMedio),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF023542).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: const Color(0xFF023542),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Color _getTarjaColor(String tarja) {
    switch (tarja.toLowerCase()) {
      case 'preta':
        return const Color(0xFF2C2C2C);
      case 'vermelha':
        return const Color(0xFFD32F2F);
      case 'amarela':
        return const Color(0xFFFBC02D);
      default:
        return const Color(0xFF4CAF50); // Livre
    }
  }

  String _getTarjaAbbreviation(String tarja) {
    switch (tarja.toLowerCase()) {
      case 'preta':
        return 'Preta';
      case 'vermelha':
        return 'Verm';
      case 'amarela':
        return 'Amar';
      default:
        return 'Livre';
    }
  }

  IconData _getMedicationIcon(String formato) {
    switch (formato.toLowerCase()) {
      case 'comprimido':
      case 'comprimidos':
        return Icons.egg_outlined;
      case 'cápsula':
      case 'capsula':
      case 'cápsulas':
        return Icons.circle_outlined;
      case 'líquido':
      case 'liquido':
      case 'soluto':
        return Icons.water_drop_outlined;
      case 'creme':
      case 'pomada':
        return Icons.invert_colors_on_outlined;
      case 'spray':
        return Icons.air_outlined;
      case 'injetável':
      case 'injetavel':
        return Icons.medical_services_outlined;
      default:
        return Icons.medication_outlined;
    }
  }

  String _formatPrice(double price) {
    return 'R\$${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}