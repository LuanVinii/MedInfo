enum CodigoErro {
  redeInacessivel,
  servidorFalhou,
  erroDesconhecido
}

abstract class AppException {
  CodigoErro get codigo;
  String get mensagem;
}