class Vendedor {
  final String nome;
  final String telefone;
  final String email;
  final String cpf;
  final String linkVendas;
  final String linkQrcode;
  final int quantidadeVendas;

  Vendedor({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cpf,
    required this.linkVendas,
    required this.linkQrcode,
    required this.quantidadeVendas,
  });

  // Método para converter Vendedor para JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'cpf': cpf,
      'link_vendas': linkVendas,
      'link_qrcode': linkQrcode,
      'quantidade_vendas': quantidadeVendas,
    };
  }

  // Método para criar um Vendedor a partir de JSON
  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      cpf: json['cpf'],
      linkVendas: json['link_vendas'],
      linkQrcode: json['link_qrcode'],
      quantidadeVendas: json['quantidade_vendas'],
    );
  }
}
