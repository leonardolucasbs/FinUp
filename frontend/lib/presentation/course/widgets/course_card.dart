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
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: AppActionButton(
                    onPressed: isUpdating ? null : onToggleSubscription,
                    icon: isSubscribed
                        ? Icons.check_circle_rounded
                        : Icons.add_circle_outline_rounded,
                    label: isSubscribed ? 'Inscrito OK' : 'Inscrever-se',
                    foregroundColor:
                        isSubscribed ? AppColors.primaryOrange : Colors.white,
                    isLoading: isUpdating,
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
