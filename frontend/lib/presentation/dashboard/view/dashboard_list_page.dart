import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/dashboard_model.dart';
import 'package:frontend/presentation/common/view/empty_feature_page.dart';
import 'package:frontend/presentation/dashboard/controller/dashboard_list_controller.dart';
import 'package:frontend/presentation/dashboard/view/dashboard_page.dart';
import 'package:frontend/presentation/content/view/content_page.dart';
import 'package:frontend/presentation/dashboard/widgets/create_dashboard_sheet.dart';
import 'package:frontend/presentation/widgets/nav_footer.dart';
import 'package:frontend/presentation/dashboard/widgets/dashboard_control_card.dart';
import 'package:frontend/presentation/widgets/nav_header.dart';
import 'package:frontend/presentation/dashboard/widgets/dashboard_header.dart';
import 'package:frontend/presentation/profile/view/profile_page.dart';

class DashboardListPage extends StatefulWidget {
  const DashboardListPage({super.key, required this.user});

  final AppUser user;

  @override
  State<DashboardListPage> createState() => _DashboardListPageState();
}

class _DashboardListPageState extends State<DashboardListPage> {
  late final DashboardListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardListController(user: widget.user)..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                DashboardHeader(
                  user: widget.user,
                  onAvatarTap: () => _openTab(DashboardTab.profile),
                  onMenuTap: () => _showMessage('Menu indisponivel.'),
                ),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
          bottomNavigationBar: DashboardBottomNav(
            activeTab: DashboardTab.home,
            onTabSelected: _openTab,
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (_controller.errorMessage != null && _controller.dashboards.isEmpty) {
      return _ListErrorState(
        message: _controller.errorMessage!,
        onRetry: _controller.load,
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      backgroundColor: AppColors.cardGrey,
      onRefresh: _controller.load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_controller.errorMessage != null) ...[
              _InlineError(message: _controller.errorMessage!),
              const SizedBox(height: 14),
            ],
            const Center(
              child: Text(
                'Controles de gastos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 26),
            Wrap(
              spacing: 10,
              runSpacing: 12,
              children: [
                ..._controller.dashboards.map(
                  (dashboard) => DashboardControlCard(
                    dashboard: dashboard,
                    onTap: () => _openDashboard(dashboard),
                  ),
                ),
                CreateDashboardControlCard(onTap: _showCreateSheet),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateSheet() async {
    final createdDashboard = await showModalBottomSheet<DashboardModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withValues(alpha: 0.55),
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => CreateDashboardSheet(
        onCreate: (title, fixedValue) async {
          final dashboard = await _controller.createDashboard(
            title: title,
            fixedValue: fixedValue,
          );
          if (dashboard == null) {
            if (mounted && _controller.errorMessage != null) {
              _showMessage(_controller.errorMessage!);
            }
          }
          return dashboard;
        },
      ),
    );

    if (createdDashboard != null && mounted) {
      _openDashboard(createdDashboard);
    }
  }

  Future<void> _openDashboard(
    DashboardModel dashboard, {
    bool replace = false,
  }) async {
    final route = MaterialPageRoute<bool>(
      builder: (_) =>
          DashboardPage(user: widget.user, initialDashboard: dashboard),
    );
    if (replace) {
      Navigator.pushReplacement(context, route);
    } else {
      final deleted = await Navigator.push<bool>(context, route);
      if (deleted == true && mounted) {
        _controller.load();
      }
    }
  }

  void _openTab(DashboardTab tab) {
    switch (tab) {

      case DashboardTab.saved:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ContentPage(user: widget.user),
          ),
        );
        break;

      case DashboardTab.courses:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmptyFeaturePage(
            title: _titleFor(tab),
            icon: _iconFor(tab),
            activeTab: tab,
            user: widget.user,
            ),
          ),
        );
        return;

      case DashboardTab.home:
        return;

      case DashboardTab.profile:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmptyFeaturePage(
            title: _titleFor(tab),
            icon: _iconFor(tab),
            activeTab: tab,
            user: widget.user,
            ),
          ),
        );
        break;
    }
  }

  String _titleFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.saved => 'Salvos',
      DashboardTab.courses => 'Cursos',
      DashboardTab.profile => widget.user.fullName,
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.35)),
      ),
      child: Text(message, style: const TextStyle(color: Colors.white70)),
    );
  }
}

class _ListErrorState extends StatelessWidget {
  const _ListErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.primaryOrange,
              size: 38,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
