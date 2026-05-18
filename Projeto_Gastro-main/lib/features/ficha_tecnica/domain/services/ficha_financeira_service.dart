import '../entities/ingrediente_entity.dart';

class FichaFinanceiraService {

  static double calcularCustoTotal(
    List<IngredienteEntity> ingredientes,
  ) {

    return ingredientes.fold(
      0.0,
      (sum, item) => 
          sum + item.custoTotal,
    );
  }

  static double calcularCustoPorPorcao({
    required double custoTotal,
    required int porcoes,
  }) {

    if (porcoes == 0) {
      return 0;
    }

    return custoTotal / porcoes;
  }

  static double calcularPrecoSugerido({
    required double custoTotal,
    required double margemLucro,
  }) {

    return custoTotal * (
      1 + margemLucro / 100
    );
  }

  static double calcularFoodCost({
    required double custoTotal,
    required double precoVenda,
  }) {

    if (precoVenda == 0) {
      return 0;
    }

    return (
      custoTotal / precoVenda
    ) * 100;
  }
}