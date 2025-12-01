import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/view_models/navigation.dart';
import '/views/perfil.dart';

class AppContentWrapper extends StatelessWidget {
  final double backgroundOpacity;
  final Color overlayColor;
  final Widget child;

  const AppContentWrapper({
    required this.child,
    this.backgroundOpacity = 0.27,
    this.overlayColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Container(decoration: _background(), child: child));
  }

  BoxDecoration _background() {
    return BoxDecoration(color: overlayColor,  image: _configuredImage());
  }

  DecorationImage _configuredImage() {
    return DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
      opacity: backgroundOpacity,
    );
  }
}

class UserAppBar extends ConsumerWidget {
  const UserAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_menuLateral(), _logo(), _avatar(context, ref)]
        )
    );
  }

  Widget _menuLateral() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.menu, color: Color(0xFF023542), size: 30),
    );
  }

  Widget _logo() {
    return Image.asset('assets/images/logo.png', height: 60);
  }

  Widget _avatar(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(navigationViewModelProvider.notifier).changeView(
          const PerfilView(),
          context,
        );
      },
      icon: const Icon(Icons.account_circle, color: Color(0xFF023542), size: 35),
    );
  }
}

class NavigationBar extends ConsumerWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(navigationViewModelProvider);
    return BottomNavigationBar(
        currentIndex: state.currentIndex,
        backgroundColor: Color(0xFF023542),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
        type: BottomNavigationBarType.fixed, // Importante para mais de 3 itens
        onTap: (index) {
          ref.read(navigationViewModelProvider.notifier).navigateByIndex(index, context);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 36),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services, size: 36),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, size: 36),
            label: 'Salvos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 36),
            label: 'Ajustes',
          )
        ]
    );
  }

}

class AppScaffold extends StatelessWidget {
  final List<Widget> mainContent;
  final bool scrollable;

  const AppScaffold({
    super.key,
    this.mainContent = const [],
    this.scrollable = true
  });

  @override
  Widget build(BuildContext context) {
    return AppContentWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: PreferredSize(preferredSize: Size.fromHeight(150), child: UserAppBar()),

        body: scrollable
            ? SingleChildScrollView(child: Column(children: mainContent))
            : Column(children: mainContent),

        bottomNavigationBar: NavigationBar(),
      ),
    );
  }
}

Widget loadingIndicator() => LinearProgressIndicator(
  minHeight: 7,
  backgroundColor: Colors.white,
  color: Color(0xFF246678),
);

Widget mainLogo({double scale = 1}) => SizedBox(
  width: 280 * scale,
  height: 95 * scale,
  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
);