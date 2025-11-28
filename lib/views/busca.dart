import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/view_models/busca.dart';
import 'package:medinfo/widgets/globais.dart';

import '../models/medicamento.dart';

class BuscaView extends ConsumerWidget {
  const BuscaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var buscaState = ref.watch(buscaViewModelProvider);

    return AppScaffold(mainContent: [
      buscaState.estaCarregando? loadingIndicator() : SizedBox(),
      searchingBar(ref),

      buscaState.medicamentos.isNotEmpty? buildMedicamentoList(buscaState.medicamentos) : SizedBox(),
    ]);
  }

}

Widget searchingBar(WidgetRef ref) => Container(
    width: double.infinity,
    color: const Color(0xFF023542),
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
    child: TextField(
      onChanged: (term) => ref.read(buscaViewModelProvider.notifier).buscarMedicamentos(term),
      onTap: () => () => (),
      decoration: InputDecoration(
        hintText: 'Pesquisar...',
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          color: Color(0xFF023542),
          onPressed: () => (),

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
    ));












Widget buildMedicamentoList(List<Medicamento> medicamentos) {
  if (medicamentos.isEmpty) {
    return const Center(
      child: Text(
        'Nenhum medicamento encontrado',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  return ListView.separated(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: medicamentos.length,
    separatorBuilder: (context, index) => const SizedBox(height: 4),
    itemBuilder: (context, index) {
      final medicamento = medicamentos[index];
      return MedicamentoCardCompact(
        medicamento: medicamento,
        onTap: () {
          // Aqui você pode adicionar a navegação para os detalhes
          // _navigateToMedicamentoDetails(context, medicamento);
        },
      );
    },
  );
}

class MedicamentoCardCompact extends StatelessWidget {
  final Medicamento medicamento;
  final VoidCallback? onTap;

  const MedicamentoCardCompact({
    super.key,
    required this.medicamento,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Indicador de tarja
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTarjaColor(medicamento.tarja.nome),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

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
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      medicamento.laboratorio.nome,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Preço
              Text(
                _formatPrice(medicamento.precoMedio),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023542),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTarjaColor(String tarja) {
    switch (tarja.toLowerCase()) {
      case 'preta': return Colors.black;
      case 'vermelha': return Colors.red;
      case 'amarela': return Colors.yellow;
      default: return Colors.green;
    }
  }

  String _formatPrice(double price) {
    return 'R\$${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

class HeaderSection extends ConsumerWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF023542),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          // Campo de pesquisa
          TextField(
            onTap: () => () => (),
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Color(0xFF023542),
                onPressed: () => (),

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

          // Lista das categorias com animação no clique
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(child: _CategoryChip(icon: Icons.medication_liquid, label: 'Antigripais')),
              SizedBox(width: 8),
              Flexible(child: _CategoryChip(icon: Icons.medication, label: 'Analgésico')),
              SizedBox(width: 8),
              Flexible(child: _CategoryChip(icon: Icons.local_hospital, label: 'Antialérgico')),
            ],
          ),

          const SizedBox(height: 15),

          // Botão de adicionar item
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Color(0xFF023542), size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final IconData icon;
  final String label;

  const _CategoryChip({required this.icon, required this.label});

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Controla o efeito de diminuir e voltar ao tamanho normal
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

    // Define o tamanho inicial
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    // Libera o controller quando o chip não existir mais
    _controller.dispose();
    super.dispose();
  }

  // Função que dispara o efeito completo
  void _animate() async {
    await _controller.reverse();
    await _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animate,
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
                  widget.label,
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


