class Medicamento {
  final int id;
  final String nome;                 
  final List<String> icones;
  final String imagemReal;           
  final String indicacao;            
  final String dosagemRecomendada;   
  final String precaucoes;    
  final String efeitosColaterais;       
  final int categoriaId;             // relacionamento com Categoria

  Medicamento({
    required this.id,
    required this.nome,
    required this.icones,
    required this.imagemReal,
    required this.indicacao,
    required this.dosagemRecomendada,
    required this.precaucoes,
    required this.efeitosColaterais,
    required this.categoriaId,
  });
}
