import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar para a área de transferência
import 'package:vendor_registration/modules/home/home_service.dart';
import 'package:vendor_registration/modules/vendedor/vendedor_model.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import 'package:vendor_registration/shared/utils/encrypt.dart';

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

  void submitForm(BuildContext context) async {
  if (formKey.currentState!.validate()) {
    final String name = nameController.text;
    final String phone = phoneController.text;
    final String email = emailController.text;
    final String cpfCnpj = cpfCnpjController.text;

    // Criptografar o CPF/CNPJ
    final String cpfCnpjEncrypted = EncryptionHelper.encryptCPF(cpfCnpj);

    // Gerar o link base
    final String link = "https://vendasonline.uniodontogoiania.com.br/home/$cpfCnpjEncrypted";

    try {
      // Gerar o QR Code antes de salvar o vendedor
      final String qrCodeUrl = await homeService.generateQRCode(link);

      if (qrCodeUrl.isEmpty) {
        _showErrorDialog(context, "Erro ao gerar o QR Code. Tente novamente.");
        return;
      }

      // Criar o objeto Vendedor com o link do QR Code
      Vendedor vendedor = Vendedor(
        nome: name,
        telefone: phone,
        email: email,
        cpf: cpfCnpj,
        linkVendas: link,
        linkQrcode: qrCodeUrl,
        quantidadeVendas: 0,
      );

      // Salvar os dados do vendedor no backend
      final String createResponse = await homeService.criarVendedor(vendedor);

      if (createResponse == "success") {
        _showLinkDialog(context, link, qrCodeUrl);
      } else {
        _showErrorDialog(context, createResponse);
      }
    } catch (error) {
      _showErrorDialog(context, "Erro ao processar: $error");
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Por favor, preencha todos os campos corretamente."),
      ),
    );
  }
}
  void _showLinkDialog(BuildContext context, String link, String qrCodeUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Link gerado com sucesso!"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(link,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (qrCodeUrl.isNotEmpty)
                SizedBox(
                  width: 200,
                  child: Image.network(
                    qrCodeUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: link));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Link copiado para a área de transferência!")),
                  );
                },
                child: const Text("Copiar Link"),
              ),
              const SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.print),
                onPressed: () {
                  final url = qrCodeUrl; // Substitua pelo link desejado
                  html.window.open(url, '_blank');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }
}
