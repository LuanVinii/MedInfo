import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  final Widget child;
  
  const GlobalBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      
        Container(color: Colors.white),
        
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),
        
       
        child,
      ],
    );
  }
}