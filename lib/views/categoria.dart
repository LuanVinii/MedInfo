import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/categoria.dart';
import '../models/medicamento.dart';
import '../view_models/categoria.dart';
import '../widgets/globais.dart';
import '../views/medicamento.dart';

class CategoriaView extends ConsumerWidget {
  final Categoria categoria;

  const CategoriaView({super.key, required this.categoria});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoriaViewModelProvider(categoria));

    return AppScaffold(
      mainContent: [
        _header(context),
        const SizedBox(height: 10),
        _conteudo(state, context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, size: 28, color: Color(0xFF023542)),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              categoria.nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023542),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Icon(Icons.search, size: 28, color: Color(0xFF023542)),
        ],
      ),
    );
  }

  Widget _conteudo(CategoriaViewModelState state, BuildContext context) {
    if (state.estaCarregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.erro != null) {
      return Center(child: Text("Erro: ${state.erro}"));
    }

    final lista = state.medicamentos ?? [];

    if (lista.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: Text("Nenhum medicamento encontrado.")),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: lista.length,
      itemBuilder: (_, i) {
        return _cardMedicamento(context, lista[i]);
      },
    );
  }

  Widget _cardMedicamento(BuildContext context, Medicamento m) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicamentoView(medicamento: m),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF023542),
              child: const Icon(Icons.medication, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.nome,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023542),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${m.categoria.nome} • ${m.viaAdministracao.descricao}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 28, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}