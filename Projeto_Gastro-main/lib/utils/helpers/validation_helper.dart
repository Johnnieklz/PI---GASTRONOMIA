class ValidationHelper {
  // Validar e-mail
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validar senha (mínimo 6 caracteres)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Validar telefone (10-11 dígitos)
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10,11}$');
    return phoneRegex.hasMatch(phone);
  }

  // Validar campo obrigatório
  static bool isRequired(String? value) {
    return value != null && value.isNotEmpty;
  }

  // Validar confirmação de senha
  static bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Validar CPF (simples)
  static bool isValidCPF(String cpf) {
    final cleanCPF = cpf.replaceAll(RegExp(r'\D'), '');
    return cleanCPF.length == 11;
  }
}
