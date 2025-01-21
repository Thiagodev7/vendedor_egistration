import 'package:flutter/material.dart';
import 'package:vendor_registration/modules/home/home_service.dart';
import 'package:vendor_registration/modules/vendedor/vendedor_model.dart';

class HomeController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();

  final HomeService homeService = HomeService();

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

  // Método para submeter o formulário e criar um vendedor
  void submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final String name = nameController.text;
      final String phone = phoneController.text;
      final String email = emailController.text;
      final String cpfCnpj = cpfCnpjController.text;

      // Gerar link personalizado
      final String link = "https://meusite.com/vendedor/$name";

      // Criar o objeto Vendedor
      Vendedor vendedor = Vendedor(
        nome: name,
        telefone: phone,
        email: email,
        cpf: cpfCnpj,
        linkVendas: link,
        quantidadeVendas: 0,  // Defina a quantidade de vendas conforme necessário
      );

      // Chamar o método do serviço para criar o vendedor
      bool sucesso = await homeService.criarVendedor(vendedor);

      if (sucesso) {
        // Exibir mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vendedor criado com sucesso!")),
        );
      } else {
        // Exibir mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar vendedor! Tente novamente mais tarde.")),
        );
      }

      // Limpar os campos após o cadastro
      // nameController.clear();
      // phoneController.clear();
      // emailController.clear();
      // cpfCnpjController.clear();
    } else {
      // Exibir mensagem de erro se o formulário não for válido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, preencha todos os campos corretamente.")),
      );
    }
  }
}
