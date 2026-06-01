import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Lista simulada de posts (Mock) até fazermos o endpoint de posts no Kotlin
  final List<Map<String, String>> _mockPosts = [
    {
      "username": "Cauã",
      "title": "FinUp Autenticação",
      "content": "Conexão efetuada com sucesso entre o Flutter e o Spring Boot! O sistema de Login e Cadastro já está funcional."
    },
    {
      "username": "Kotlin Bot",
      "title": "Spring Boot Status",
      "content": "Endpoint /users/login a responder corretamente na porta 8080."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "FinUp Feed",
          style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _mockPosts.length,
        itemBuilder: (context, index) {
          final post = _mockPosts[index];
          return PostCard(
            username: post["username"]!,
            title: post["title"]!,
            content: post["content"]!,
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.cardGrey, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primaryOrange,
          unselectedItemColor: AppColors.textGrey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 28), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border, size: 28), label: "Salvos"),
            BottomNavigationBarItem(icon: Icon(Icons.book_outlined, size: 28), label: "Livros"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 28), label: "Perfil"),
          ],
        ),
      ),
    );
  }
}