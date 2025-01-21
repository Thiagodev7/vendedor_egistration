import 'package:flutter/material.dart';

class HomeController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite o nome";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite o telefone";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite o e-mail";
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return "E-mail inválido";
    }
    return null;
  }

  String? validateCpfCnpj(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite o CPF ou CNPJ";
    }
    if (value.length != 11 && value.length != 14) {
      return "Digite um CPF ou CNPJ válido";
    }
    return null;
  }

  void submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final String name = nameController.text;
      final String phone = phoneController.text;
      final String email = emailController.text;
      final String cpfCnpj = cpfCnpjController.text;

      // Gerar link personalizado
      final String link = "https://meusite.com/vendedor/$name";

      // Simular envio para o backend
      print("Dados enviados: $name, $phone, $email, $cpfCnpj");
      print("Link Gerado: $link");

      // Exibir mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Link Gerado: $link")),
      );

      // Limpar os campos após o cadastro
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      cpfCnpjController.clear();
    }
  }
}
