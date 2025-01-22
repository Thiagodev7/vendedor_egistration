import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar para a área de transferência
import 'package:vendor_registration/modules/home/home_service.dart';
import 'package:vendor_registration/modules/vendedor/vendedor_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        quantidadeVendas: 0,
      );

      // Chamar o método do serviço para criar o vendedor
       bool sucesso = await homeService.criarVendedor(vendedor);
       final qrCodeUrl = await homeService.generateQRCode(link);

      if (sucesso && qrCodeUrl.isNotEmpty) {
        // Exibir popup com o link gerado e o QR Code
        _showLinkDialog(context, link, qrCodeUrl);
      } else {
        // Exibir mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Erro ao criar vendedor! Tente novamente mais tarde.")),
        );
      }

      // Limpar os campos após o cadastro
      // nameController.clear();
      // phoneController.clear();
      // emailController.clear();
      // cpfCnpjController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Por favor, preencha todos os campos corretamente.")),
      );
    }
  }

  // Função para exibir o popup com o link e o QR Code
  void _showLinkDialog(BuildContext context, String link, String qrCodeUrl) {
    final String proxyUrl = 'https://cors-anywhere.herokuapp.com/';
final String proxiedUrl = qrCodeUrl;
    print(qrCodeUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Link gerado com sucesso!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(link,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (qrCodeUrl.isNotEmpty)
              // SizedBox(
              //   width: 150,
              //   height: 150,
              //   child: CachedNetworkImage(
              //     imageUrl: qrCodeUrl,
              //     placeholder: (context, url) =>
              //         const CircularProgressIndicator(),
              //     errorWidget: (context, url, error) => const Icon(Icons.error),
              //     httpHeaders: {
              //       "Access-Control-Allow-Origin": "*"
              //     }, // Adicione, se necessário
              //   ),
              // ),
            Image.network(proxiedUrl),
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o popup
            },
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> fetchImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Erro ao carregar a imagem');
  }
}

Widget buildImage(String url) {
  return FutureBuilder<Uint8List>(
    future: fetchImage(url),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Icon(Icons.error);
      } else {
        return Image.memory(snapshot.data!);
      }
    },
  );
}

}
