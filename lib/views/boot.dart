import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/view_models/categorias.dart';
import '/views/login.dart';
import '/widgets/globais.dart';

class BootView extends ConsumerStatefulWidget {
  const BootView({super.key});

  @override
  ConsumerState<BootView> createState() => _BootViewState();

}

class _BootViewState extends ConsumerState<BootView> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(categoriasViewModelProvider.notifier).obterTodas());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriasViewModelProvider);

    ref.listen<CategoriasViewModelState>(categoriasViewModelProvider,
          (previous, next) {
        if (!next.estaCarregando && next.erro == null) {
          _toLoginView();
        }
      },
    );

    return AppContentWrapper(child: _viewHandler(state));
  }

  Widget _viewHandler(CategoriasViewModelState state) {
    if (state.erro != null ) {
      return _ErrorView();
    }
    return _LoadingView();
  }

  void _toLoginView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    });
  }

}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CategoriasViewModelState state = ref.watch(categoriasViewModelProvider);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          mainLogo(),
          _spacer(20),
          _errorMessage(state),
          _spacer(10),
          _refreshButton(ref)
        ]);
  }

  Widget _errorMessage(CategoriasViewModelState state) {
    String errorMessage = state.erro?.mensagem ?? 'Falha no carregamento interno do app!';
    return Text(errorMessage, style: TextStyle(
        color: Color(0xFF023542),
        fontFamily: 'Roboto',
        decoration: TextDecoration.none,
        fontSize: 16,
        fontWeight: FontWeight.normal
    ));
  }

  Widget _spacer(double height) => SizedBox(
      height: height
  );

  Widget _refreshButton(WidgetRef ref) => ElevatedButton(
      onPressed: ref.read(categoriasViewModelProvider.notifier).obterTodas,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 50),
          backgroundColor: Colors.white,
          shape: CircleBorder()
      ),
      child: Icon(Icons.refresh,
          size: 28,
          color: Color(0xFF023542)
      )
  );

}

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _loadingIndicator(),
      _InfoView()
    ]);
  }

  Widget _loadingIndicator() {
    return LinearProgressIndicator(
      minHeight: 7,
      backgroundColor: Colors.white,
      color: Color(0xFF246678),
    );
  }
}

class _InfoView extends StatelessWidget {
  final Color fontColor;
  final String fontFamily;

  const _InfoView({
    this.fontColor = const Color(0xFF023542),
    this.fontFamily = 'Roboto',
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: _infoContent()));
  }

  Widget _infoContent() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        mainLogo(),
        _spacer(70),
        _title('Desenvolvido por...'),
        _spacer(10),
        _mainText('Arthur de Aquino'),
        _mainText('Denilson Santos'),
        _mainText('Laysa Lima'),
        _mainText('Luan Vinicius'),
        _spacer(60),
        _mainText('© Todos os direitos reservados')
      ]
  );

  Widget _spacer(double height) => SizedBox(
      height: height
  );

  Widget _title(String name) => _text(
    text: name,
    fontSize: 28,
    fontWeight:FontWeight.w500,
  );

  Widget _mainText(String name) => _text(
    text: name,
    fontSize: 20,
    fontWeight:FontWeight.w400,
  );

  Widget _text({required text, required double fontSize, required FontWeight fontWeight}) => Text(text,
      style: TextStyle(
          color: fontColor,
          fontFamily: fontFamily,
          decoration: TextDecoration.none,
          fontSize: fontSize,
          fontWeight: fontWeight
      )
  );

}