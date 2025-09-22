import 'package:flutter/material.dart';
import 'widgets/global_background.dart';
import 'views/categoria_screen.dart';

void main() {
  runApp(const MedInfoApp());
}

class MedInfoApp extends StatelessWidget {
  const MedInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // ← MaterialApp DEVE VIR PRIMEIRO
      title: 'MedInfo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: GlobalBackground( // ← GlobalBackground DENTRO do home
        child: CategoriaScreen(),
      ),
    );
  }
}