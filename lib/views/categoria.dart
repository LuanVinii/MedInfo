import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/models/categoria.dart';

import '../widgets/globais.dart';

class CategoriaView extends ConsumerWidget {
  final Categoria categoria;

  const CategoriaView({super.key, required this.categoria});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(mainContent: [Center(child: Text('data'),)],);
  }

}