import 'package:flutter/material.dart';
import 'package:vendor_registration/modules/home/home_controller.dart';
import 'package:vendor_registration/shared/utils/colors.dart';
import 'package:vendor_registration/shared/widgets/backgroun_decoration.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: lilacColor),
      filled: true,
      fillColor: offWhiteColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: lilacColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: purpleColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BackgroundDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/images/white_logo.png',
                      fit: BoxFit.contain,
                      height: 130,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _controller.formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Cadastro de Vendedores',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Gere aqui seu link para vendas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controller.nameController,
                        decoration: _inputDecoration("Nome", Icons.person),
                        validator: _controller.validateName,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _controller.phoneController,
                        decoration: _inputDecoration("Telefone", Icons.phone),
                        keyboardType: TextInputType.phone,
                        validator: _controller.validatePhone,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _controller.emailController,
                        decoration: _inputDecoration("E-mail", Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: _controller.validateEmail,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _controller.cpfCnpjController,
                        decoration:
                            _inputDecoration("CPF ou CNPJ", Icons.credit_card),
                        keyboardType: TextInputType.number,
                        validator: _controller.validateCpfCnpj,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _controller.submitForm(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Gerar Link",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
