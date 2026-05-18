class FichaTecnicaValidator {

  static String? validarNome(
    String? value,
  ) {

    if (value == null || value.trim().isEmpty) {
      return "Informe o nome da receita";
    }

    if (value.trim().length < 3) {
      return "Nome muito curto";
    }

    return null;
  }

  static String? validarCategoria(
    String? value,
  ) {

    if (value == null || value.isEmpty) {
      return "Selecione uma categoria";
    }

    return null;
  }

  static String? validarPorcoes(
    String? value,
  ) {

    if (value == null || value.isEmpty) {
      return "Informe as porções";
    }

    final porcoes =
        int.tryParse(value);

    if (porcoes == null) {
      return "Número inválido";
    }

    if (porcoes <= 0) {
      return "Porções devem ser maiores que zero";
    }

    return null;
  }

  static String? validarTempo(
    String? value,
  ) {

    if (value == null || value.isEmpty) {
      return "Informe o tempo";
    }

    final tempo =
        int.tryParse(value);

    if (tempo == null) {
      return "Tempo inválido";
    }

    if (tempo <= 0) {
      return "Tempo deve ser maior que zero";
    }

    return null;
  }

  static String? validarLucro(
    String? value,
  ) {

    if (value == null || value.isEmpty) {
      return "Informe a margem";
    }

    final lucro =
        double.tryParse(
      value.replaceAll(',', '.'),
    );

    if (lucro == null) {
      return "Valor inválido";
    }

    if (lucro < 0) {
      return "Lucro inválido";
    }

    return null;
  }

  static String? validarIngredientes(
    int quantidade,
  ) {

    if (quantidade <= 0) {
      return "Adicione ingredientes";
    }

    return null;
  }
}