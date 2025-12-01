import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/models/medicamento.dart';
import 'package:medinfo/view_models/bookmarks.dart';
import 'package:medinfo/view_models/navigation.dart';
import 'package:medinfo/view_models/usuario.dart';
import 'package:medinfo/views/medicamento.dart';

import '../widgets/globais.dart';

const Color _primaryColor = Color(0xFF023542);
const Color _tarjaColor = Color(0xFFC62828);

class BookmarksView extends ConsumerWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookmarksViewModelProvider);

    if (state.medicamentosSalvos.isEmpty && !state.estaCarregando) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(bookmarksViewModelProvider.notifier).obterMedicamentosSalvos();
        });
    }

    return AppScaffold(
      scrollable: false,
      mainContent: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: _primaryColor,
          child: const Text(
            "Salvos", 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Expanded(
          child: state.estaCarregando
                ? const Center(child: CircularProgressIndicator(color: _primaryColor))
                : state.medicamentosSalvos.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Nenhum medicamento salvo.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    itemCount: state.medicamentosSalvos.length,
                    itemBuilder: (context, index) {
                      final medicamento = state.medicamentosSalvos[index];
                      return _MedicamentoCard(
                        medicamento: medicamento,
                        key: ValueKey(medicamento.id),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

class _MedicamentoCard extends ConsumerStatefulWidget {
  final Medicamento medicamento;

  const _MedicamentoCard({
    required this.medicamento,
    super.key,
  });

  @override
  ConsumerState<_MedicamentoCard> createState() => _MedicamentoCardState();
}

class _MedicamentoCardState extends ConsumerState<_MedicamentoCard> {
  double _opacity = 1.0;
  double _scale = 1.0;

  void _onToggleFavorite() async {
    setState(() {
      _opacity = 0.0;
      _scale = 0.9;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    final usuarioNotifier = ref.read(usuarioViewModelProvider.notifier);
    await usuarioNotifier.desfavoritarMedicamento(widget.medicamento);

    ref.read(bookmarksViewModelProvider.notifier).obterMedicamentosSalvos();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1.0,
              ),
            ),

            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: _primaryColor.withOpacity(0.05),
              highlightColor: Colors.transparent,

              onTap: () {
                ref.read(navigationViewModelProvider.notifier).changeView(
                  MedicamentoView(medicamento: widget.medicamento),
                  context,
                );
              },

              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 5,
                      decoration: const BoxDecoration(
                        color: _primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.medicamento.nome} ${widget.medicamento.formato.descricao}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            Text(
                              "${widget.medicamento.categoria.nome} • ${widget.medicamento.laboratorio.nome}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 2),

                            Text(
                              "Tarja: ${widget.medicamento.tarja.nome}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _tarjaColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.bookmark,
                              color: _primaryColor,
                              size: 24,
                            ),
                            onPressed: _onToggleFavorite,
                            splashRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}