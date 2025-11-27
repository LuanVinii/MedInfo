import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/globais.dart';

class MedicamentoView extends ConsumerWidget {
  const MedicamentoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      UserAppBar()
    ]);
  }

}