import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/presentation/content/view/content_page.dart';
import 'package:frontend/presentation/course/view/course_page.dart';
import 'package:frontend/presentation/widgets/nav_footer.dart';
import 'package:frontend/presentation/profile/view/profile_page.dart';
import 'package:frontend/presentation/dashboard/view/dashboard_list_page.dart';

class EmptyFeaturePage extends StatelessWidget {
  const EmptyFeaturePage({
    super.key,
    required this.title,
    required this.icon,
    required this.activeTab,
    required this.user,
  });

  final String title;
  final IconData icon;
  final DashboardTab activeTab;
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardGrey,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primaryOrange, size: 42),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'tela em construcao',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: activeTab,
        onTabSelected: (tab) => _openTab(tab, context),
      ),
    );
  }

    void _openTab(DashboardTab tab, BuildContext context) {
      switch (tab) {

        case DashboardTab.saved:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ContentPage(user: user),
            ),
          );
          break;

        case DashboardTab.courses:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CoursesPage(user: user),
            ),
          );
          break;

        case DashboardTab.home:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardListPage(user: user),
            ),
          );
          break;

        case DashboardTab.profile:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(user: user),
            ),
          );
          break;
      }
  }

  String _titleFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.saved => 'Salvos',
      DashboardTab.courses => 'Cursos',
      DashboardTab.profile => user.fullName,
      DashboardTab.home => 'Home',
    };
  }

  IconData _iconFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.saved => Icons.bookmark_rounded,
      DashboardTab.courses => Icons.school_rounded,
      DashboardTab.profile => Icons.person_rounded,
      DashboardTab.home => Icons.home_rounded,
    };
  }
}
