import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vendor_registration/modules/vendedor/vendedor_model.dart';
import 'package:http/http.dart' as http;

class HomeService {
  static const String baseUrl =
      'http://localhost:3000/vendedores'; // URL da sua API (use 10.0.2.2 para emulador)

  // Método para criar um novo vendedor
  Future<bool> criarVendedor(Vendedor vendedor) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(vendedor.toJson()),
      );

      // Verificar status da resposta
      if (response.statusCode == 201) {
        // Sucesso
        return true;
      } else {
        // Falha na resposta, talvez erro de validação
        print('Falha ao criar vendedor: ${response.body}');
        return false;
      }
    } catch (e) {
      // Tratar erro de rede ou qualquer outro erro
      print("Erro ao criar vendedor: $e");

      // Verificando o tipo de erro
      if (e is http.ClientException) {
        print('Erro de conexão com a API: ${e.message}');
      } else if (e is SocketException) {
        print('Erro de rede: Não foi possível conectar ao servidor');
      } else {
        print('Erro desconhecido: $e');
      }

      return false;
    }
  }

  // Função para gerar o QR Code usando a API do QRplus
  Future<String> generateQRCode(String link) async {
    const String qrPlusApiUrl = "https://pro.qrplus.com.br/api/v1/qrcode";
    const String apiKey =
        "tLdZevkAF8G1huf8uAVyNHOV37qopq+nga78WbnbRI9jkfikEerlw03YjJwTMbcpPKTEzOYf7k9I/yOAJfD5kTe9KoQweMWNLFL8sLYu7Qg=";

    try {
      final response = await http.post(
        Uri.parse(qrPlusApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": apiKey,
        },
        body: json.encode({
          "Title": "Vendedor Link", // Título do QR Code
          "Dynamic": true, // Define se o QR Code será dinâmico ou estático
          "Type": "url", // Tipo do QR Code (neste caso, um link)
          "Content": "https://meusite.com/vendedor/dgdgdg"
          //"Logo": null // URL do logo ou null se não houver logo
        }),
      );

      if (response.statusCode == 200) {
         final data = json.decode(response.body);
      
      return data["data"]["image"]; 
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['data'] ?? "Erro desconhecido";
        print("Erro: $errorMessage");
        return "";
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return "";
    }
  }
}
