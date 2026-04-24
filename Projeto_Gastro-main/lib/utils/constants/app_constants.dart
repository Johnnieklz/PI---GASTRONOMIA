class AppConstants {
  // Validações
  static const String emailRegex = r'^[^@]+@[^@]+\.[^@]+';
  static const String phoneRegex = r'^\d{10,11}$';
  
  // Mensagens
  static const String errorMessage = 'Algo deu errado. Tente novamente.';
  static const String emailInvalidMessage = 'E-mail inválido.';
  static const String passwordMinLength = 'Senha deve ter no mínimo 6 caracteres.';
  static const String requiredField = 'Este campo é obrigatório.';
  
  // Timeout
  static const int apiTimeout = 30;
  
  // URLs (exemplo)
  static const String baseUrl = 'https://api.example.com';
}
