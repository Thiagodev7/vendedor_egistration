import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar para a área de transferência
import 'package:vendor_registration/modules/home/home_service.dart';
import 'package:vendor_registration/modules/vendedor/vendedor_model.dart';
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
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
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
      final String cpfCnpjEncrypted = EncryptionHelper.encryptCPF(cpfCnpj);

      // Gerar o link base
      final String link = "https://vendasonline.uniodontogoiania.com.br/home/$cpfCnpjEncrypted";

      try {
        // Verificar se o vendedor já existe
        final existingVendedor = await homeService.getVendedorByCpf(cpfCnpj);
        if (existingVendedor != null) {
          // Exibir o link e o QR Code do vendedor existente
          _showLinkDialog(context, existingVendedor.linkVendas, existingVendedor.linkQrcode);
          return;
        }
        //   // Gerar o QR Code
          final String qrCodeUrl = await homeService.generateQRCode(link);
          if (qrCodeUrl.isEmpty) {
            _showErrorDialog(context, "Erro ao gerar o QR Code. Tente novamente.");
            return;
          }

          print("qrcode $qrCodeUrl");

          // Atualizar o vendedor com o QR Code
          Vendedor vendedor = Vendedor(
            nome: name,
            telefone: phone,
            email: email,
            cpf: cpfCnpj,
            linkVendas: link,
            linkQrcode: qrCodeUrl,
            quantidadeVendas: 0,
          );

          // Salvar os dados do vendedor no backend novamente
          await homeService.criarVendedor(vendedor);
          _showLinkDialog(context, link, qrCodeUrl);
        // } else {
        //   _showErrorDialog(context, createResponse);
        // }
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
              Text(link, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    const SnackBar(content: Text("Link copiado para a área de transferência!")),
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
