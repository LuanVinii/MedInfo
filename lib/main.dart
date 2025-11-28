import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/views/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/boot.dart';

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

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove a faixa de debug
      debugShowCheckedModeBanner: false,
      // Nome exibido em lugares do sistema
      title: 'MedInfo',
      home: HomeView(),
    );
  }

}