import '/exceptions/base.dart';

class InternetException implements AppException {

  @override
  CodigoErro get codigo => CodigoErro.redeInacessivel;

  @override
  String get mensagem => "Falha na conexão! Verifique a internet...";

}

class ServidorException implements AppException {

  @override
  CodigoErro get codigo => CodigoErro.servidorFalhou;

  @override
  String get mensagem => "Falha interna do servidor! Tente mais tarde...";

}

class ErroDesconhecidoException implements AppException {

  @override
  CodigoErro get codigo => CodigoErro.erroDesconhecido;

  @override
  String get mensagem => "Erro tenebroso! Fim de jogo.";

}