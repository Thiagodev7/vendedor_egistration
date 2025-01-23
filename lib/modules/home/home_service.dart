import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vendor_registration/modules/vendedor/vendedor_model.dart';

class HomeService {
  static const String baseUrl =
      'http://localhost:3000/vendedores'; // URL da sua API

  Future<String> criarVendedor(Vendedor vendedor) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(vendedor.toJson()),
      );

      if (response.statusCode == 201) {
        return "success";
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? "Erro desconhecido";
        return errorMessage;
      }
    } catch (e) {
      if (e is SocketException) {
        return "Erro de rede: Não foi possível conectar ao servidor.";
      } else {
        return "Erro desconhecido: $e";
      }
    }
  }

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
          "Title": "Vendedor Link",
          "Dynamic": true,
          "Type": "url",
          "Content": link,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["data"]["image"];
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['data'] ?? "Erro desconhecido";
        return "";
      }
    } catch (e) {
      return "";
    }
  }
}
