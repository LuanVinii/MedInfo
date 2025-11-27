import 'package:flutter/material.dart';

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

class UserAppBar extends StatelessWidget {
  const UserAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_menuLateral(), _logo(), _avatar()]
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

  Widget _avatar() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.account_circle, color: Color(0xFF023542), size: 35),
    );
  }
}

Widget mainLogo({double scale = 1}) => SizedBox(
  width: 280 * scale,
  height: 95 * scale,
  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
);