import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/view_models/bookmarks.dart';
import 'package:medinfo/view_models/usuario.dart';
import '../widgets/globais.dart';
import '../models/medicamento.dart';

final _buttonLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

class MedicamentoView extends ConsumerWidget {
  final Medicamento medicamento;

  const MedicamentoView({super.key, required this.medicamento});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isButtonLoading = ref.watch(_buttonLoadingProvider);

    final bookmarksState = ref.watch(bookmarksViewModelProvider);
    final isSaved = bookmarksState.medicamentosSalvos.any((m) => m.id == medicamento.id);
    
    final usuarioNotifier = ref.read(usuarioViewModelProvider.notifier);
    final usuarioState = ref.watch(usuarioViewModelProvider);

    Color buttonColor = isSaved ? const Color(0xFFC62828) : Colors.green;
    IconData buttonIcon = isSaved ? Icons.bookmark_remove : Icons.bookmark;
    String buttonText = isSaved ? "Remover favorito" : "Salvar medicamento";

    void toggleFavorite() async {
      if (!usuarioState.estaAutenticado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Faça login para salvar medicamentos."),
            backgroundColor: Color(0xFFC62828),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      
      ref.read(_buttonLoadingProvider.notifier).state = true;
      
      try {
        if (isSaved) {
          await usuarioNotifier.desfavoritarMedicamento(medicamento);
        } else {
          await usuarioNotifier.favoritarMedicamento(medicamento);
        }

        ref.read(bookmarksViewModelProvider.notifier).obterMedicamentosSalvos();

      } finally {
        ref.read(_buttonLoadingProvider.notifier).state = false;
      }
    }

    return AppScaffold(
      mainContent: [
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, size: 32, color: Color(0xFF004D61)),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Center(
          child: Text(
            medicamento.nome,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D61),
            ),
          ),
        ),

        const SizedBox(height: 25),

        _buildAccordion(medicamento),
        const SizedBox(height: 25),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isButtonLoading ? null : toggleFavorite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    disabledBackgroundColor: buttonColor.withOpacity(0.5), 
                  ),
                  child: isButtonLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(buttonIcon, color: Colors.white, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              buttonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccordion(Medicamento medicamento) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          MedicationTile(
            titulo: "Indicação",
            conteudo: "Indicação não informada.",
          ),
          MedicationTile(
            titulo: "Dosagem recomendada",
            conteudo: "Via de administração: ${medicamento.viaAdministracao.descricao}",
          ),
          MedicationTile(
            titulo: "Precauções",
            conteudo: "Tarja: ${medicamento.tarja.nome}",
          ),
          MedicationTile(
            titulo: "Preço",
            conteudo: "Preço médio: R\$ ${medicamento.precoMedio.toStringAsFixed(2)}",
          ),
        ],
      ),
    );
  }
}

class MedicationTile extends StatelessWidget {
  final String titulo;
  final String conteudo;

  const MedicationTile({
    super.key,
    required this.titulo,
    required this.conteudo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF004D61),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          title: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                conteudo,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}