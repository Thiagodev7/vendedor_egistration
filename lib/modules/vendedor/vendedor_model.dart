class Vendedor {
  final String nome;
  final String telefone;
  final String email;
  final String cpfCnpj;
  String? linkDeVendas; // O link será gerado após o cadastro

  Vendedor({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cpfCnpj,
    this.linkDeVendas,
  });

  // Método para converter os dados para um mapa (útil para enviar ao backend)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'cpfCnpj': cpfCnpj,
      'linkDeVendas': linkDeVendas,
    };
  }

  // Método para criar um objeto Vendedor a partir de um mapa (útil para receber do backend)
  factory Vendedor.fromMap(Map<String, dynamic> map) {
    return Vendedor(
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      email: map['email'] ?? '',
      cpfCnpj: map['cpfCnpj'] ?? '',
      linkDeVendas: map['linkDeVendas'],
    );
  }

  @override
  String toString() {
    return 'Vendedor(nome: $nome, telefone: $telefone, email: $email, cpfCnpj: $cpfCnpj, linkDeVendas: $linkDeVendas)';
  }
}
