import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/content_model.dart';
import 'package:frontend/data/services/content_service.dart';
import 'package:frontend/data/services/saved_content_service.dart';
import 'package:frontend/data/services/user_service.dart';
import 'package:frontend/presentation/common/view/empty_feature_page.dart';
import 'package:frontend/presentation/content/controller/content_controller.dart';
import 'package:frontend/presentation/content/widgets/create_content_sheet.dart';
import 'package:frontend/presentation/dashboard/view/dashboard_list_page.dart';
import 'package:frontend/presentation/profile/view/profile_page.dart';
import 'package:frontend/presentation/widgets/nav_footer.dart';
import 'package:frontend/presentation/widgets/nav_header.dart';

import 'package:intl/intl.dart';


class ContentPage extends StatefulWidget {
  const ContentPage({super.key, required this.user});

  final AppUser user;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late final ContentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ContentController(
      user: widget.user,
      contentService: ContentService(),
      savedContentService: SavedContentService(),
    )..load();
    
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
                  onAvatarTap: () => _openTab(DashboardTab.saved),
                  onMenuTap: () => _showMessage('Menu indisponivel.'),
                ),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
          bottomNavigationBar: DashboardBottomNav(
            activeTab: DashboardTab.saved,
            onTabSelected: _openTab,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _controller.isSubmitting ? null : _showCreateSheet,
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_rounded),
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

    if (_controller.errorMessage != null) {
      return _ContentErrorState(
        message: _controller.errorMessage!,
        onRetry: _controller.load,
      );
    }

    if (_controller.contents.isEmpty) {
      return const _ContentEmptyState();
    }

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      backgroundColor: AppColors.cardGrey,
      onRefresh: _controller.load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        itemCount: _controller.contents.length,
        itemBuilder: (context, index) {
          final content = _controller.contents[index];
          final isOwner = _controller.isOwner(content);
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == _controller.contents.length - 1 ? 0 : 14,
            ),
            child: ContentCard(
              content: content,
              saveCount: _controller.saveCountFor(
                content.id,
              ),
              isSaved: _controller.hasUserSaved(content.id),
              isSaving: _controller.isSavingContent(content.id),
              isActionDisabled: _controller.isSubmitting,
              onEdit: isOwner ? () => _showEditSheet(content) : null,
              onDelete: isOwner
                  ? () => _confirmDeleteContent(content)
                  : null,
              onToggleSaved: isOwner ? null : () => _toggleSaved(content),
            ),
          );
        },
      ),
    );
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(user: widget.user),
          ),
        );
        break;
    }
  }

  String _titleFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.home    => 'Home',
      DashboardTab.saved   => 'Conteúdo',
      DashboardTab.courses => 'Cursos',
      DashboardTab.profile => 'Meu Perfil',
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

  Future<void> _showCreateSheet() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => CreateContentSheet(
        isSubmitting: _controller.isSubmitting,
        onSubmit: _controller.createContent,
      ),
    );

    if (!mounted) return;

    if (created == true) {
      _showMessage('Conteudo criado com sucesso.');
      return;
    }

    final errorMessage = _controller.submissionErrorMessage;
    if (errorMessage != null) {
      _showMessage(errorMessage);
    }
  }

  Future<void> _showEditSheet(ContentModel content) async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => CreateContentSheet(
        isSubmitting: _controller.isSubmitting,
        initialContent: content,
        onSubmit: ({
          required title,
          required description,
          required type,
          imageUrl,
        }) =>
            _controller.updateContent(
              content: content,
              title: title,
              description: description,
              type: type,
              imageUrl: imageUrl,
            ),
      ),
    );

    if (!mounted) return;

    if (updated == true) {
      _showMessage('Conteudo atualizado com sucesso.');
      return;
    }

    final errorMessage = _controller.submissionErrorMessage;
    if (errorMessage != null) {
      _showMessage(errorMessage);
    }
  }

  Future<void> _confirmDeleteContent(ContentModel content) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cardGrey,
          surfaceTintColor: AppColors.cardGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Delete Content',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to permanently delete this content?',
            style: TextStyle(
              color: AppColors.textGrey,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    final deleted = await _controller.deleteContent(content);
    if (!mounted) return;

    if (deleted) {
      _showMessage('Conteudo excluido com sucesso.');
      return;
    }

    final errorMessage = _controller.submissionErrorMessage;
    if (errorMessage != null) {
      _showMessage(errorMessage);
    }
  }

  Future<void> _toggleSaved(ContentModel content) async {
    final wasSaved = _controller.hasUserSaved(content.id);
    final changed = await _controller.toggleSaved(content);
    if (!mounted) return;

    if (changed) {
      _showMessage(
        wasSaved
            ? 'Conteudo removido dos salvos.'
            : 'Conteudo salvo com sucesso.',
      );
      return;
    }

    final errorMessage = _controller.submissionErrorMessage;
    if (errorMessage != null) {
      _showMessage(errorMessage);
    }
  }
}

class ContentCard extends StatelessWidget {
  final UserService _userService = UserService(); 
  
  ContentCard({
    super.key,
    required this.content,
    required this.saveCount,
    required this.isSaved,
    required this.isSaving,
    required this.isActionDisabled,
    this.onEdit,
    this.onDelete,
    this.onToggleSaved,
  });

  final ContentModel content;
  final int saveCount;
  final bool isSaved;
  final bool isSaving;
  final bool isActionDisabled;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleSaved;

  static final DateFormat _createdAtFormat = DateFormat(
    'dd/MM/yyyy HH:mm',
    'pt_BR',
  );

  @override
  Widget build(BuildContext context) {
    final contentImageUrl = content.imageUrl.trim();
    final canManageContent = onEdit != null || onDelete != null;
    final canSaveContent = !canManageContent && onToggleSaved != null;

    return FutureBuilder<AppUser>(
        future: _userService.getUserById(userId: content.userId),
        builder: (context, snapshot) {
      
          String fullName = "Carregando...";
          String avatarUrl = '';
          
          if (snapshot.hasData) {
            fullName = snapshot.data!.fullName;
            avatarUrl = snapshot.data!.avatarUrl ?? '';

          } else if (snapshot.hasError) {
            fullName = "Usuário desconhecido";

          }
          
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardGrey,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.background.withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ContentAvatar(
                      imageUrl: avatarUrl,
                      fallbackText: fullName,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            content.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.border),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (contentImageUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          contentImageUrl,
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      content.description,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, thickness: 1, color: AppColors.border),
                    const SizedBox(height: 12),
                    Text(
                      'Salvos: $saveCount',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Criado em: ${_createdAtFormat.format(content.createdAt)}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (canManageContent)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _ContentActionButton(
                            onPressed: isActionDisabled ? null : onEdit,
                            icon: Icons.edit_rounded,
                            label: 'Edit',
                            foregroundColor: AppColors.muted,
                          ),
                          const SizedBox(width: 8),
                          _ContentActionButton(
                            onPressed: isActionDisabled ? null : onDelete,
                            icon: Icons.delete_outline_rounded,
                            label: 'Delete',
                            foregroundColor: AppColors.primaryRed,
                          ),
                        ],
                      )
                    else if (canSaveContent)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _ContentActionButton(
                          onPressed: isSaving ? null : onToggleSaved,
                          icon: isSaved
                              ? Icons.bookmark_added_rounded
                              : Icons.bookmark_add_outlined,
                          label: isSaved ? 'Salvo ✓' : 'Salvar',
                          foregroundColor: AppColors.primaryOrange,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          );
        }
      );
    }
  }

class _ContentActionButton extends StatelessWidget {
  const _ContentActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.foregroundColor,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        disabledForegroundColor: AppColors.muted.withValues(alpha: 0.45),
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _ContentAvatar extends StatelessWidget {
  const _ContentAvatar({required this.imageUrl, required this.fallbackText});

  final String imageUrl;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final source = imageUrl.trim();

    return ClipOval(
      child: SizedBox(
        width: 46,
        height: 46,
        child: source.isEmpty
            ? _AvatarFallback(text: fallbackText)
            : Image.network(
                source,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _AvatarFallback(text: fallbackText),
              ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final initial = text.trim().isEmpty ? 'U' : text.trim()[0].toUpperCase();

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.inputField,
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.primaryOrange,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ContentErrorState extends StatelessWidget {
  const _ContentErrorState({required this.message, required this.onRetry});

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

class _ContentEmptyState extends StatelessWidget {
  const _ContentEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              color: AppColors.primaryOrange,
              size: 40,
            ),
            SizedBox(height: 12),
            Text(
              'Nenhum conteúdo publicado ainda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
