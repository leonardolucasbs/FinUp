import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../home/view/home_page.dart'; // Importa a Home para navegar
import '../../signup/view/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para capturar o texto digitado
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  void _executeLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos.', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Chama a API do Kotlin
      final success = await _authRepository.login(email, password);

      if (success && mounted) {
        _showSnackBar('Login realizado com sucesso!', Colors.green);
        
        // Navega para a HomePage e destrói a tela de login do histórico
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (error) {
      // Mostra o erro exato retornado pelo Kotlin (ex: "E-mail ou senha incorretos.")
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
                      _tabButton("Entrar", true),
                      _tabButton("Cadastrar", false),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Inputs vinculados aos controllers
                  _buildInput("E-mail", _emailController, Icons.email_outlined, false),
                  const SizedBox(height: 20),
                  _buildInput("Senha", _passwordController, Icons.lock_outline, true),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Esqueceu a senha?", style: TextStyle(color: AppColors.primaryOrange)),
                    ),
                  ),

                  const SizedBox(height: 15),
                  
                  // Botão Entrar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _isLoading ? null : _executeLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Entrar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Não tem uma conta? ", style: TextStyle(color: AppColors.textGrey)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
                  },
                  child: const Text("Cadastre-se", style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                ),
              ],
            )
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
        onTap: () {
          if (!active) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
          }
        },
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