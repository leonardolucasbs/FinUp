import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/dashboard_model.dart';
import 'dashboard_formatters.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({super.key, required this.dashboard});

  final DashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F232C), Color(0xFF11141B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 26,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'valor mensal',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            DashboardFormatters.currency(dashboard.fixedBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'valor restante',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primaryOrange, Color(0xFFFFB066)],
              ).createShader(bounds),
              child: Text(
                DashboardFormatters.currency(dashboard.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          const Text(
            'quanto gastei',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            DashboardFormatters.currency(dashboard.expenses),
            style: const TextStyle(
              color: Color(0xFFFF8B8B),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
