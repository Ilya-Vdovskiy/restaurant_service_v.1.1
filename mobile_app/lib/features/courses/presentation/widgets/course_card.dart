import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.items,
    super.key,
  });

  final String title;
  final String subtitle;
  final int progress;
  final List<CourseContentItem> items;

  bool get isCompleted => progress >= 100;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CourseProgress(progress: progress),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final item in items) ...[
                _ContentTypeIcon(item: item),
                const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (isCompleted)
            const _CompletedState()
          else
            _CourseActionButton(
              text: progress == 0 ? 'Начать' : 'Продолжить',
              onTap: () => context.push(AppRoutes.courseDetail),
            ),
        ],
      ),
    );
  }
}

class CourseContentItem {
  const CourseContentItem({required this.type, required this.completed});

  final CourseContentType type;
  final bool completed;
}

enum CourseContentType { video, article, test, recipe }

class _CourseProgress extends StatelessWidget {
  const _CourseProgress({required this.progress});

  final int progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress / 100,
            minHeight: 8,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Прогресс', style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(
              '$progress%',
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContentTypeIcon extends StatelessWidget {
  const _ContentTypeIcon({required this.item});

  final CourseContentItem item;

  @override
  Widget build(BuildContext context) {
    final icon = switch (item.type) {
      CourseContentType.video => Icons.play_arrow_outlined,
      CourseContentType.article => Icons.description_outlined,
      CourseContentType.test => Icons.check_circle_outline,
      CourseContentType.recipe => Icons.menu_book_outlined,
    };

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: item.completed ? AppColors.gold.withOpacity(0.18) : AppColors.surfaceLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: item.completed ? AppColors.gold : AppColors.textTertiary,
        size: 18,
      ),
    );
  }
}

class _CourseActionButton extends StatelessWidget {
  const _CourseActionButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

class _CompletedState extends StatelessWidget {
  const _CompletedState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: Color(0xFF22C55E), size: 20),
          SizedBox(width: 8),
          Text(
            'Завершено',
            style: TextStyle(
              color: Color(0xFF22C55E),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
