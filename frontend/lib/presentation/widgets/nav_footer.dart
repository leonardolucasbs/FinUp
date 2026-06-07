import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

enum DashboardTab { home, saved, courses, profile }

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  final DashboardTab activeTab;
  final ValueChanged<DashboardTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.cardGrey,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_rounded,
            active: activeTab == DashboardTab.home,
            onTap: () => onTabSelected(DashboardTab.home),
          ),
          _NavItem(
            label: 'Conteúdo',
            icon: Icons.bookmark_rounded,
            active: activeTab == DashboardTab.saved,
            onTap: () => onTabSelected(DashboardTab.saved),
          ),
          _NavItem(
            label: 'Cursos',
            icon: Icons.school_rounded,
            active: activeTab == DashboardTab.courses,
            onTap: () => onTabSelected(DashboardTab.courses),
          ),
          _NavItem(
            label: 'Perfil',
            icon: Icons.person_rounded,
            active: activeTab == DashboardTab.profile,
            onTap: () => onTabSelected(DashboardTab.profile),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryOrange : AppColors.muted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
