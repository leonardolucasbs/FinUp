import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  void _executeRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validação visual rápida
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Preencha todos os campos!', Colors.red);
      return;
    }
    if (password.length < 8) {
      _showSnackBar('A senha deve ter no mínimo 8 caracteres (Regra do seu Backend).', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _authRepository.register(
        fullName: name,
        email: email,
        password: password,
      );

      if (success) {
        _showSnackBar('Conta criada com sucesso!', Colors.green);
        if (mounted) Navigator.pop(context); // Volta para a tela de login
      }
    } catch (error) {
    
      _showSnackBar(error.toString().replaceAll('Exception: ', ''), Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/images/logo_finup.png', height: 60),
            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  // Abas superiores
                  Row(
                    children: [
                      _tabButton("Entrar", false),
                      _tabButton("Cadastrar", true),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Inputs usando Controllers normais do Flutter para acoplamento simples
                  _buildInput("Nome Completo", _nameController, Icons.person_outline, false),
                  const SizedBox(height: 20),
                  _buildInput("E-mail", _emailController, Icons.email_outlined, false),
                  const SizedBox(height: 20),
                  _buildInput("Senha", _passwordController, Icons.lock_outline, true),

                  const SizedBox(height: 30),
                  
                  // Botão de Criar Conta Inteligente
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _isLoading ? null : _executeRegister,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Criar Conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputField,
            prefixIcon: Icon(icon, color: AppColors.textGrey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _tabButton(String title, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () { if (!active) Navigator.pop(context); },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(title, style: TextStyle(color: active ? Colors.white : AppColors.textGrey, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}