import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/course_model.dart';
import 'package:frontend/presentation/widgets/shared_ui.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.isSubscribed,
    required this.isUpdating,
    required this.onToggleSubscription,
  });

  final CourseModel course;
  final bool isSubscribed;
  final bool isUpdating;
  final VoidCallback onToggleSubscription;

  @override
  Widget build(BuildContext context) {
    final imageUrl = course.imageUrl.trim();

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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: SizedBox(
              width: double.infinity,
              height: 165,
              child: imageUrl.isEmpty
                  ? const _CourseImagePlaceholder()
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const _CourseImagePlaceholder(),
                    ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title.isNotEmpty ? course.title : 'Curso sem titulo',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (course.teacher.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_rounded,
                        color: AppColors.muted,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          course.teacher,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (course.description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    course.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppActionButton(
                        onPressed: () => _showCourseDescription(context),
                        icon: Icons.info_outline_rounded,
                        label: 'Ver descricao',
                        foregroundColor: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppActionButton(
                        onPressed: isUpdating ? null : onToggleSubscription,
                        icon: isSubscribed
                            ? Icons.check_circle_rounded
                            : Icons.add_circle_outline_rounded,
                        label: isSubscribed ? 'Inscrito OK' : 'Inscrever-se',
                        foregroundColor: isSubscribed
                            ? AppColors.primaryOrange
                            : Colors.white,
                        isLoading: isUpdating,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseDescription(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _CourseDescriptionDialog(course: course),
    );
  }
}

class _CourseDescriptionDialog extends StatelessWidget {
  const _CourseDescriptionDialog({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final locationLabel = course.courseType == 'PRESENCIAL'
        ? 'Endereco'
        : 'Plataforma';

    return AlertDialog(
      backgroundColor: AppColors.cardGrey,
      surfaceTintColor: AppColors.cardGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      title: Text(
        course.title.isNotEmpty ? course.title : 'Curso sem titulo',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.description.isNotEmpty
                  ? course.description
                  : 'Sem descricao cadastrada.',
              style: const TextStyle(
                color: AppColors.textGrey,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            _CourseInfoRow(
              icon: Icons.computer_rounded,
              label: 'Tipo de curso',
              value: _formatEnum(course.courseType),
            ),
            _CourseInfoRow(
              icon: Icons.place_rounded,
              label: locationLabel,
              value: course.location,
            ),
            _CourseInfoRow(
              icon: Icons.schedule_rounded,
              label: 'Horas do curso',
              value: course.courseHours > 0 ? '${course.courseHours}h' : '',
            ),
            _CourseInfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'Data de inicio',
              value: _formatDate(course.startDate),
            ),
            _CourseInfoRow(
              icon: Icons.signal_cellular_alt_rounded,
              label: 'Nivel',
              value: _formatEnum(course.level),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Fechar',
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseInfoRow extends StatelessWidget {
  const _CourseInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isNotEmpty
        ? value.trim()
        : 'Nao informado';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryOrange, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayValue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.25,
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

String _formatEnum(String value) {
  switch (value) {
    case 'PRESENCIAL':
      return 'Presencial';
    case 'REMOTO':
      return 'Remoto';
    case 'INICIANTE':
      return 'Iniciante';
    case 'INTERMEDIARIO':
      return 'Intermediario';
    case 'AVANCADO':
      return 'Avancado';
    default:
      return value;
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return '';

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

class _CourseImagePlaceholder extends StatelessWidget {
  const _CourseImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inputField,
      child: const Center(
        child: Icon(
          Icons.school_rounded,
          color: AppColors.primaryOrange,
          size: 44,
        ),
      ),
    );
  }
}
