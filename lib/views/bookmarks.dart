import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/globais.dart';

class BookmarksView extends ConsumerWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      UserAppBar()
    ]);
  }

}