class FichaCategoria {

  final String label;
  final String value;

  const FichaCategoria({
    required this.label,
    required this.value,
  });
}

class FichaCategoriaConstants {

  static const categorias = [

    FichaCategoria(
      label: "Massas",
      value: "massas",
    ),

    FichaCategoria(
      label: "Sobremesas",
      value: "sobremesas",
    ),

    FichaCategoria(
      label: "Bebidas",
      value: "bebidas",
    ),

    FichaCategoria(
      label: "Lanches",
      value: "lanches",
    ),

    FichaCategoria(
      label: "Entradas",
      value: "entradas",
    ),

    FichaCategoria(
      label: "Carnes",
      value: "carnes",
    ),

    FichaCategoria(
      label: "Pizzas",
      value: "pizzas",
    ),

    FichaCategoria(
      label: "Hambúrgueres",
      value: "hamburgueres",
    ),

    FichaCategoria(
      label: "Pratos Executivos",
      value: "pratos_executivos",
    ),
  ];
}