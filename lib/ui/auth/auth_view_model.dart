import 'package:app_recipes/data/repositories/auth_repository.dart';
import 'package:app_recipes/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthViewModel extends GetxController {
  final _repository = getIt<AuthRepository>();

  // Form
  final formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final avatarUrlController = TextEditingController();

  // Estados
  final _obscurePassword = true.obs;
  final _isSubmitting = false.obs;
  final _isLoginMode = true.obs;
  final _errorMessage = ''.obs;

  // Getters
  bool get obscurePassword => _obscurePassword.value;
  bool get isSubmitting => _isSubmitting.value;
  bool get isLoginMode => _isLoginMode.value;
  String get errorMessage => _errorMessage.value;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe o e-mail';
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ).hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Precisa de letra minúscula';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Precisa de letra maiúscula';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Precisa de número';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\/;]').hasMatch(value)) {
      return 'Precisa de caractere especial';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirme a senha';
    if (value != passwordController.text) return 'As senhas não coincidem';
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Informe o nome de usuário';
    if (value.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  String? validateAvatarUrl(String? value) {
    if (value == null || value.isEmpty) return 'Informe a URL do avatar';
    if (!RegExp(
      r'^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w- ./?%&=]*)?$',
    ).hasMatch(value)) {
      return 'URL inválida';
    }
    return null;
  }

  void toggleObscurePassword() =>
      _obscurePassword.value = !_obscurePassword.value;

  Future<void> submit() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    _isSubmitting.value = true;

    if (isLoginMode) {
      await login();
    } else {
      await register();
    }
  }

  Future<void> login() async {
print('login start');
    final response = await _repository.signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    );

print('login after');

print(response.right.toString());
    response.fold((left) => _errorMessage.value = left.message, (right) {
      print(right);

      return;
    });
  }

  Future<void> register() async {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    avatarUrlController.dispose();
    super.onClose();
  }

  void toggleMode() {
    _isLoginMode.value = !_isLoginMode.value;
    _isSubmitting.value = false;
    _clearFields();
    _obscurePassword.value = true;

    // * update
    // Necessário para atualizar a UI
    update();
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    usernameController.clear();
    avatarUrlController.clear();
  }
}
