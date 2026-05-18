class IngredienteEntity {

  final String nome;

  final double quantidade;

  final String unidade;

  final double precoUnitario;

  final double fatorCorrecao;

  const IngredienteEntity({

    required this.nome,

    required this.quantidade,

    required this.unidade,

    required this.precoUnitario,

    this.fatorCorrecao = 1.0,
  });

  double get quantidadeCorrigida {

    return quantidade *
        fatorCorrecao;
  }

  double get custoTotal {

    return quantidadeCorrigida *
        precoUnitario;
  }

  Map<String, dynamic> toJson() {

    return {

      "nome": nome,

      "quantidade":
          quantidade,

      "unidade":
          unidade,

      "preco_unitario":
          precoUnitario,

      "fator_correcao":
          fatorCorrecao,
    };
  }

  factory IngredienteEntity.fromJson(
    Map<String, dynamic> json,
  ) {

    return IngredienteEntity(

      nome:
          json["nome"] ?? "",

      quantidade:
          (json["quantidade"] ?? 0)
              .toDouble(),

      unidade:
          json["unidade"] ?? "g",

      precoUnitario:
          (json["preco_unitario"] ?? 0)
              .toDouble(),

      fatorCorrecao:
          (json["fator_correcao"] ?? 1.0)
              .toDouble(),
    );
  }
}