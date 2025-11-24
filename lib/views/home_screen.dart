import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart'; // Importa widgets compartilhados como AppBar e HeaderSection

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

  @override
  Widget build(BuildContext context) {
    // O Scaffold é o esqueleto da tela, mas com fundo transparente
    // Para permitir que o widget GlobalBackground apareça atrás
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar reutilizável do projeto
            const CustomAppBar(),

            // Faixa azul do topo com o título e ícone
            const HeaderSection(), 
            
            // Toda a parte de conteúdo abaixo pode rolar
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  // Coluna principal da Home
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pequeno espaçamento após o header
                      const SizedBox(height: 10), 

                      // Caixa do aviso ("Atenção!")
                      DisclaimerBox(
                        isAcknowledged: _disclaimerAcknowledged,
                        onAcknowledge: _acknowledgeDisclaimer,
                      ),

                      const SizedBox(height: 20),

                      // Aqui futuramente entram categorias, medicamentos recentes, etc.
                      // ...
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // Botão "Quero saber mais" (ainda sem lógica)
              TextButton(
                onPressed: () {
                  // Navegação futura para uma tela explicando mais detalhes
                },
                child: const Text(
                  "Quero saber mais", 
                  style: TextStyle(
                    color: Color(0xFF023542), 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                  ),
                ),
              ),
              
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
