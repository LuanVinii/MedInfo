import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/view_models/navigation.dart';
import 'package:medinfo/views/busca.dart';

import '/widgets/globais.dart';

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

              // // Botão "Quero saber mais" (ainda sem lógica)
              // TextButton(
              //   onPressed: () {
              //     // Navegação futura para uma tela explicando mais detalhes
              //   },
              //   child: const Text(
              //     "Quero saber mais",
              //     style: TextStyle(
              //       color: Color(0xFF023542),
              //       fontWeight: FontWeight.bold,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),

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
            onTap: () => ref.read(navigationViewModelProvider.notifier).changeView(BuscaView(), context),
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Color(0xFF023542),
                onPressed: () => ref.read(navigationViewModelProvider.notifier).changeView(BuscaView(), context),

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


