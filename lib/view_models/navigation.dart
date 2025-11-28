import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medinfo/views/ajustes.dart';
import 'package:medinfo/views/bookmarks.dart';
import 'package:medinfo/views/categorias.dart';
import 'package:medinfo/widgets/globais.dart';

import '../views/home.dart';

final List<Widget> _mainViews = [
  HomeView(),
  CategoriasView(),
  BookmarksView(),
  AjustesView()
];

class NavigationViewModel extends StateNotifier<NavigationViewModelState> {

  NavigationViewModel() : super(NavigationViewModelState());

  void navigateByIndex(index, context) {
    state = NavigationViewModelState(currentIndex: index);
  }

  void changeView(Widget targetView, BuildContext context, {int? newIndex}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => targetView),
      );
    });
    if (newIndex != null) {
      state = NavigationViewModelState(currentIndex: newIndex);
    }
  }

}

class NavigationViewModelState {
  int currentIndex;

  NavigationViewModelState({this.currentIndex = 0});

  Widget get currentView => _mainViews[currentIndex];

}

var navigationViewModelProvider = StateNotifierProvider<NavigationViewModel, NavigationViewModelState>(
    (ref) => NavigationViewModel()
);