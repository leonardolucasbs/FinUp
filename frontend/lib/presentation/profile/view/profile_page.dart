import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/content_model.dart';
import 'package:frontend/data/services/content_service.dart';
import 'package:frontend/presentation/profile/controller/profile_controller.dart';
import 'package:frontend/presentation/widgets/shared_ui.dart';
import 'package:frontend/presentation/course/view/course_page.dart';
import 'package:frontend/presentation/widgets/nav_footer.dart';
import 'package:frontend/presentation/login/view/login_page.dart';
import 'package:frontend/presentation/profile/view/edit_profile_page.dart';
import '../../dashboard/view/dashboard_list_page.dart';
import 'package:frontend/presentation/content/view/content_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});

  final AppUser user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController _controller;
  late AppUser _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _controller = ProfileController(
      user: _user,
      contentService: ContentService(),
    )..loadPosts();
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
        final initial = _initialFor(_user.fullName);

        return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryOrange,
          backgroundColor: AppColors.cardGrey,
          onRefresh: _controller.loadPosts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 12),
                    const Text(
                      'Perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.cardGrey,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryOrange,
                              AppColors.primaryRed,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange.withValues(
                                alpha: 0.32,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        _user.fullName.isNotEmpty ? _user.fullName : 'Usuario',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _user.username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _ProfileSection(
                  title: 'Informacoes da conta',
                  children: [
                    _ProfileInfoRow(
                      icon: Icons.badge_outlined,
                      label: 'Nome completo',
                      value: _user.fullName.isNotEmpty ? _user.fullName : '-',
                    ),
                    _ProfileInfoRow(
                      icon: Icons.alternate_email_rounded,
                      label: 'E-mail',
                      value: _user.username.isNotEmpty ? _user.username : '-',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ProfileSection(
                  title: 'Acessos',
                  children: [
                    _ProfileActionRow(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Controle de gastos',
                      onTap: () => _openFeature(DashboardTab.home),
                    ),
                    _ProfileActionRow(
                      icon: Icons.edit_rounded,
                      label: 'Alterar dados do usuario',
                      onTap: _openEditProfile,
                    ),
                    _ProfileActionRow(
                      icon: Icons.school_rounded,
                      label: 'Meus cursos',
                      onTap: () => _openFeature(DashboardTab.courses),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ProfileSection(
                  title: 'Minhas postagens',
                  children: [_buildPostsContent()],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Sair da conta'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryRed,
                      side: const BorderSide(
                        color: AppColors.primaryRed,
                        width: 1.4,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardTab.profile,
        onTabSelected: _openTab,
      ),
    );
      },
    );
  }

  Widget _buildPostsContent() {
    if (_controller.isLoadingPosts) {
      return const AppLoadingState(
        padding: EdgeInsets.symmetric(vertical: 18),
      );
    }

    if (_controller.postsError != null) {
      return _PostsMessage(
        icon: Icons.error_outline_rounded,
        title: _controller.postsError!,
        actionLabel: 'Tentar novamente',
        onAction: _controller.loadPosts,
      );
    }

    if (_controller.posts.isEmpty) {
      return const _PostsMessage(
        icon: Icons.article_outlined,
        title: 'Voce ainda nao tem postagens.',
      );
    }

    return Column(
      children: _controller.posts
          .map(
            (post) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PostCard(
                post: post,
                isDeleting: _controller.isDeletingPost(post.id),
                onDelete: () => _confirmDeletePost(post),
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> _openEditProfile() async {
    final updatedUser = await Navigator.push<AppUser>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilePage(user: _user)),
    );

    if (updatedUser == null || !mounted) return;

    setState(() => _user = updatedUser);
    _controller.updateUser(updatedUser);
    await _controller.loadPosts();
  }

  String _initialFor(String name) {
    final trimmed = name.trim();
    return trimmed.isNotEmpty ? trimmed[0].toUpperCase() : 'U';
  }

  void _openTab(DashboardTab tab) {
    switch (tab) {

      case DashboardTab.saved:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ContentPage(user: _user),
          ),
        );
        break;

      case DashboardTab.courses:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CoursesPage(user: _user),
          ),
        );
        return;

      case DashboardTab.home:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardListPage(user: _user),
          ),
        );
        return;

      case DashboardTab.profile:
        return;
    }
  }

  void _openFeature(DashboardTab tab) {
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
            builder: (_) => CoursesPage(
              user: _user,
              initialShowOnlyMyCourses: true,
            ),
          ),
        );
        break;

      case DashboardTab.home:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardListPage(user: widget.user),
          ),
        );
        break;

      case DashboardTab.profile:
        return;
      }

  }

  Future<void> _confirmDeletePost(ContentModel post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDeleteDialog(
        title: 'Excluir postagem',
        message: 'Tem certeza que deseja excluir esta postagem?',
      ),
    );

    if (!mounted || confirmed != true) return;

    final deleted = await _controller.deletePost(post);
    if (!mounted) return;

    if (deleted) {
      _showMessage('Postagem excluida com sucesso.');
      return;
    }

    final errorMessage = _controller.submissionErrorMessage;
    if (errorMessage != null) {
      _showMessage(errorMessage);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String titleFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.saved => 'Salvos',
      DashboardTab.courses => 'Cursos',
      DashboardTab.profile => _user.fullName,
      DashboardTab.home => 'Home',
    };
  }

  IconData iconFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.saved => Icons.bookmark_rounded,
      DashboardTab.courses => Icons.school_rounded,
      DashboardTab.profile => Icons.person_rounded,
      DashboardTab.home => Icons.home_rounded,
    };
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _IconTile(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionRow extends StatelessWidget {
  const _ProfileActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              _IconTile(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.isDeleting,
    required this.onDelete,
  });

  final ContentModel post;
  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post.typeLabel,
                  style: const TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              AppActionButton(
                onPressed: isDeleting ? null : onDelete,
                icon: Icons.delete_outline_rounded,
                label: 'Excluir',
                foregroundColor: AppColors.primaryRed,
                isLoading: isDeleting,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.title.isNotEmpty ? post.title : 'Sem titulo',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (post.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              post.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PostsMessage extends StatelessWidget {
  const _PostsMessage({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryOrange, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textGrey),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.inputField,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: AppColors.primaryOrange, size: 21),
    );
  }
}
