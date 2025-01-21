import 'dart:convert';
import 'dart:io';
import 'package:vendor_registration/modules/vendedor/vendedor_model.dart';
import 'package:http/http.dart' as http;

class HomeService {
  static const String baseUrl = 'http://localhost:3000/vendedores'; // URL da sua API (use 10.0.2.2 para emulador)

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
}
