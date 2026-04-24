extension StringExtension on String {
  // Capitalizar primeira letra
  String get capitalize => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  // Colocar tudo em maiúsculas
  String get toUpperCaseFirst => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  // Remover espaços em branco
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  // Verificar se é um email válido
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  // Verificar se é numérico
  bool get isNumeric => double.tryParse(this) != null;

  // Truncar string com reticências
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Remover caracteres especiais
  String get removeSpecialCharacters => replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
}
