import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Importa a AppShell, que é a estrutura principal com navegação e layout
import 'package:medinfo/views/app_shell.dart';

import '/services/medicamento.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();

  String? databaseUrl = dotenv.env['SUPABASE_URL'];
  String? databaseKey = dotenv.env['SUPABASE_KEY'];

  if (databaseUrl == null) {
    throw AuthException("Variável \"SUPABASE_URL\" não definida em tempo de execução!");
  }

  if (databaseKey == null) {
    throw AuthException("Variável \"SUPABASE_KEY\" não definida em tempo de execução!");
  }

  await Supabase.initialize(url: databaseUrl, anonKey: databaseKey);

  // Inicia o app e carrega o widget principal
  runApp(ProviderScope(child: MyApp()));
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
