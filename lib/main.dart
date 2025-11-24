import 'package:flutter/material.dart';
// Importa a AppShell, que é a estrutura principal com navegação e layout
import 'package:medinfo/views/app_shell.dart'; 

void main() {
  // Inicia o app e carrega o widget principal
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove a faixa de debug
      debugShowCheckedModeBanner: false,
      // Nome exibido em lugares do sistema
      title: 'MedInfo',
      // AppShell é a base da aplicação com Footer, páginas e background
      home: const AppShell(),
    );
  }
}
