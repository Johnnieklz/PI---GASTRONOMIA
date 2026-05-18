import '../../domain/entities/ingrediente_entity.dart';

class CriarFichaTecnicaDTO {

  final String nome;
  final String categoria;
  final int tempoPreparoMin;
  final int porcoes;
  final String modoPreparo;
  final String nivelDificuldade;

  final List<IngredienteEntity> ingredientes;

  final double custoTotal;
  final double custoPorPorcao;
  final double precoSugerido;
  final double foodCost;

  const CriarFichaTecnicaDTO({
    required this.nome,
    required this.categoria,
    required this.tempoPreparoMin,
    required this.porcoes,
    required this.modoPreparo,
    required this.nivelDificuldade,
    required this.ingredientes,
    required this.custoTotal,
    required this.custoPorPorcao,
    required this.precoSugerido,
    required this.foodCost,
  });

  Map<String, dynamic> toJson() {

    return {

      "nome": nome,
      "categoria": categoria,
      "tempo_preparo_min": tempoPreparoMin,
      "porcoes": porcoes,
      "modo_preparo": modoPreparo,
      "nivel_dificuldade": nivelDificuldade,

      "ingredientes":
          ingredientes.map(
            (i) => i.toJson(),
          ).toList(),

      "custo_total": custoTotal,
      "custo_por_porcao": custoPorPorcao,
      "preco_sugerido": precoSugerido,
      "food_cost": foodCost,
    };
  }
}