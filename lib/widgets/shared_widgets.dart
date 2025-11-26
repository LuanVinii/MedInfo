import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../views/login_screen.dart';

//
// Barra superior com menu, logo e botão de perfil.
// Só cuida da parte visual do topo.
//
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Espaçamento interno da barra
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão do menu lateral
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Color(0xFF023542), size: 30),
          ),

          // Logo central. Usa fallback caso a imagem falhe
          Image.asset(
            'assets/images/logo.png',
            height: 60,
            errorBuilder: (context, error, stackTrace) {
              // Logo alternativa simples caso a imagem não exista
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Text("Med", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text("Info", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(width: 5),
                    Icon(Icons.medication, color: Colors.white, size: 20)
                  ],
                ),
              );
            },
          ),

          // Botão de perfil
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle, color: Color(0xFF023542), size: 35),
          ),
        ],
      ),
    );
  }
}

//
// Item individual do footer. Representa cada botão da barra inferior.
//
class FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  const FooterItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Muda a cor dependendo se está selecionado ou não
    final color = selected ? Colors.white : Colors.white70;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

//
// Barra inferior inteira. Controla os botões e repassa o índice selecionado.
//
class Footer extends StatelessWidget {
  final Function(int) onTapIndex;
  final int currentIndex;

  const Footer({required this.onTapIndex, required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF023542),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FooterItem(
            icon: Icons.home,
            label: 'Início',
            selected: currentIndex == 0,
            onTap: () => onTapIndex(0),
          ),
          FooterItem(
            icon: Icons.medical_services,
            label: 'Categoria',
            selected: currentIndex == 1,
            onTap: () => onTapIndex(1),
          ),
          FooterItem(
            icon: Icons.settings,
            label: 'Ajuste',
            selected: currentIndex == 2,
            onTap: () => onTapIndex(2),
          ),
        ],
      ),
    );
  }
}

//
// Área azul da home. Contém pesquisa, categorias e botão de adicionar.
//
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

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
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              suffixIcon: const Icon(Icons.search, color: Color(0xFF023542)),
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

//
// Chip individual das categorias. Possui animação rápida de clique.
//
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

//
// Tela simples usada no Footer como placeholder.
// Só mostra um texto centralizado.
//
class AjustePage extends StatelessWidget {
  const AjustePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar customizada
            const CustomAppBar(),
            
            // Header
            Container(
              width: double.infinity,
              color: const Color(0xFF023542),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: const Text(
                'Ajustes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Conteúdo
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Card de perfil
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Color(0xFF023542),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Configurações',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF023542),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Botão de logout
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Importar o serviço de auth
                        final authService = AuthService();
                        
                        try {
                          await authService.logout();
                          
                          // Navegar para a tela de login
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao fazer logout: $e'),
                                backgroundColor: Colors.red[400],
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Sair',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
