import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/dashboard_model.dart';
import 'dashboard_formatters.dart';

class DashboardControlCard extends StatelessWidget {
  const DashboardControlCard({
    super.key,
    required this.dashboard,
    required this.onTap,
  });

  final DashboardModel dashboard;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ControlCardShell(
      onTap: onTap,
      borderColor: AppColors.primaryOrange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dashboard.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DashboardFormatters.currency(dashboard.fixedBalance),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CreateDashboardControlCard extends StatelessWidget {
  const CreateDashboardControlCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ControlCardShell(
      onTap: onTap,
      backgroundColor: AppColors.primaryOrange,
      borderColor: AppColors.primaryOrange,
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryOrange.withValues(alpha: 0.35),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_rounded, color: Colors.white, size: 34),
          SizedBox(height: 8),
          Text(
            'criar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlCardShell extends StatelessWidget {
  const _ControlCardShell({
    required this.child,
    required this.onTap,
    this.backgroundColor = AppColors.cardGrey,
    this.borderColor = Colors.white70,
    this.boxShadow = const [
      BoxShadow(color: Colors.black38, blurRadius: 14, offset: Offset(0, 9)),
    ],
  });

  final Widget child;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color borderColor;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 115,
        height: 108,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.6),
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}
