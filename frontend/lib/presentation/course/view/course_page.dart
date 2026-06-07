import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/course_model.dart';
import 'package:frontend/data/services/course_service.dart';
import 'package:frontend/data/services/subscription_service.dart';
import 'package:frontend/presentation/content/view/content_page.dart';
import 'package:frontend/presentation/course/controller/course_controller.dart';
import 'package:frontend/presentation/course/widgets/course_card.dart';
import 'package:frontend/presentation/dashboard/view/dashboard_list_page.dart';
import 'package:frontend/presentation/profile/view/profile_page.dart';
import 'package:frontend/presentation/widgets/nav_footer.dart';
import 'package:frontend/presentation/widgets/nav_header.dart';
import 'package:frontend/presentation/widgets/shared_ui.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({
    super.key,
    required this.user,
    this.initialShowOnlyMyCourses = false,
  });

  final AppUser user;
  final bool initialShowOnlyMyCourses;

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class CoursePage extends CoursesPage {
  const CoursePage({
    super.key,
    required super.user,
    super.initialShowOnlyMyCourses,
  });
}

class _CoursesPageState extends State<CoursesPage> {
  late final CourseController _controller;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CourseController(
      user: widget.user,
      courseService: CourseService(),
      subscriptionService: SubscriptionService(),
      initialShowOnlyMyCourses: widget.initialShowOnlyMyCourses,
    )..load();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            activeTab: DashboardTab.courses,
            onTabSelected: _openTab,
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (_controller.isLoading) {
      return const AppLoadingState();
    }

    if (_controller.errorMessage != null && _controller.courses.isEmpty) {
      return AppErrorState(
        message: _controller.errorMessage!,
        onRetry: _controller.load,
      );
    }

    final courses = _controller.filteredCourses;

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      backgroundColor: AppColors.cardGrey,
      onRefresh: _controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          const Center(
            child: Text(
              'Cursos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          AppSearchInput(
            controller: _searchController,
            hintText: 'Pesquisar cursos',
            onChanged: _controller.setSearchTerm,
          ),
          const SizedBox(height: 12),
          AppFilterTabs(
            firstLabel: 'Todos os cursos',
            secondLabel: 'Meus cursos',
            isSecondActive: _controller.showOnlyMyCourses,
            onFirstPressed: () => _controller.setShowOnlyMyCourses(false),
            onSecondPressed: () => _controller.setShowOnlyMyCourses(true),
          ),
          if (_controller.errorMessage != null) ...[
            const SizedBox(height: 14),
            AppInlineError(message: _controller.errorMessage!),
          ],
          const SizedBox(height: 16),
          if (courses.isEmpty)
            AppEmptyState(
              icon: Icons.school_outlined,
              message: _emptyMessage(),
              compact: true,
            )
          else
            ...courses.map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CourseCard(
                  course: course,
                  isSubscribed: _controller.isSubscribed(course.id),
                  isUpdating: _controller.isUpdatingCourse(course.id),
                  onToggleSubscription: () => _toggleSubscription(course),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _emptyMessage() {
    if (_controller.searchTerm.trim().isNotEmpty) {
      return 'Nenhum curso encontrado para a pesquisa.';
    }
    if (_controller.showOnlyMyCourses) {
      return 'Voce ainda nao esta inscrito em nenhum curso.';
    }
    return 'Nenhum curso disponivel no momento.';
  }

  Future<void> _toggleSubscription(CourseModel course) async {
    final wasSubscribed = _controller.isSubscribed(course.id);
    final changed = await _controller.toggleSubscription(course);
    if (!mounted) return;

    if (changed) {
      _showMessage(
        wasSubscribed
            ? 'Inscricao removida com sucesso.'
            : 'Inscricao realizada com sucesso.',
      );
      return;
    }

    final errorMessage = _controller.submissionErrorMessage;
    if (errorMessage != null) {
      _showMessage(errorMessage);
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
        return;

      case DashboardTab.home:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardListPage(user: widget.user),
          ),
        );
        break;

      case DashboardTab.profile:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(user: widget.user),
          ),
        );
        break;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CourseSearchField extends StatelessWidget {
  const _CourseSearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      cursorColor: AppColors.primaryOrange,
      decoration: InputDecoration(
        hintText: 'Pesquisar cursos',
        hintStyle: const TextStyle(color: AppColors.muted),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.primaryOrange,
        ),
        filled: true,
        fillColor: AppColors.inputField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryOrange),
        ),
      ),
    );
  }
}

class _CourseFilterTabs extends StatelessWidget {
  const _CourseFilterTabs({
    required this.showOnlyMyCourses,
    required this.onShowAll,
    required this.onShowMine,
  });

  final bool showOnlyMyCourses;
  final VoidCallback onShowAll;
  final VoidCallback onShowMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputField,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterButton(
              label: 'Todos os cursos',
              active: !showOnlyMyCourses,
              onPressed: onShowAll,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _FilterButton(
              label: 'Meus cursos',
              active: showOnlyMyCourses,
              onPressed: onShowMine,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: active ? AppColors.primaryOrange : Colors.transparent,
        foregroundColor: active ? Colors.white : AppColors.muted,
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
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

class _CoursesErrorState extends StatelessWidget {
  const _CoursesErrorState({required this.message, required this.onRetry});

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
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 15,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoursesEmptyState extends StatelessWidget {
  const _CoursesEmptyState({
    required this.showOnlyMyCourses,
    required this.hasSearchTerm,
  });

  final bool showOnlyMyCourses;
  final bool hasSearchTerm;

  @override
  Widget build(BuildContext context) {
    final message = hasSearchTerm
        ? 'Nenhum curso encontrado para a pesquisa.'
        : showOnlyMyCourses
            ? 'Voce ainda nao esta inscrito em nenhum curso.'
            : 'Nenhum curso disponivel no momento.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.school_outlined,
            color: AppColors.primaryOrange,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
