import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/medicamento.dart';
import '../widgets/globais.dart';

class MedicamentoView extends ConsumerWidget {
  final Medicamento medicamento;

  const MedicamentoView({super.key, required this.medicamento});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppScaffold(mainContent: [
    Center(child: Text('data'))
  ]);

}
