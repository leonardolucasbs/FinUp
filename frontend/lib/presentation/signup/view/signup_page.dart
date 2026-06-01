import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/custom_text.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/custom_text.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.trending_up, color: AppColors.primaryOrange, size: 80),
            const Text("FinUp", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            
            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _tabButton("Entrar", false, context),
                      _tabButton("Cadastrar", true, context),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const CustomTextField(label: "Nome Completo", hint: "Digite seu nome", icon: Icons.person_outline),
                  const SizedBox(height: 20),
                  const CustomTextField(label: "E-mail", hint: "seu@email.com", icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  const CustomTextField(label: "Senha", hint: "........", icon: Icons.lock_outline, isPassword: true),

                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {},
                      child: const Text("Criar Conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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

  Widget _tabButton(String title, bool active, BuildContext context) {
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