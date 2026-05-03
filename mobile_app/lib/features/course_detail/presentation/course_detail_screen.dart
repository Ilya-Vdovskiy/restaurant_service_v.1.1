import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Винная карта 2026'),
        toolbarHeight: 72,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.surfaceLight, AppColors.surface],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.wine_bar_outlined, color: AppColors.gold, size: 54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('12 материалов • 1 тест', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const LinearProgressIndicator(
                            value: 0.4,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceLight,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('40% пройдено', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Материалы', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _LessonTile(
              icon: Icons.play_arrow_outlined,
              title: 'Введение в винную карту',
              subtitle: 'Видео • 8 минут',
              completed: true,
              onTap: () => context.push(AppRoutes.article),
            ),
            const SizedBox(height: 12),
            _LessonTile(
              icon: Icons.description_outlined,
              title: 'Белые и красные вина',
              subtitle: 'Статья • 6 минут',
              completed: true,
              onTap: () => context.push(AppRoutes.article),
            ),
            const SizedBox(height: 12),
            _LessonTile(
              icon: Icons.description_outlined,
              title: 'Рекомендации к блюдам',
              subtitle: 'Статья • 10 минут',
              completed: false,
              onTap: () => context.push(AppRoutes.article),
            ),
            const SizedBox(height: 12),
            _LessonTile(
              icon: Icons.quiz_outlined,
              title: 'Проверка знаний',
              subtitle: 'Тест • 12 вопросов',
              completed: false,
              onTap: () => context.push(AppRoutes.examStart),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: completed ? AppColors.gold.withOpacity(0.18) : AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: completed ? AppColors.gold : AppColors.textTertiary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Icon(completed ? Icons.check_circle : Icons.chevron_right, color: completed ? AppColors.gold : AppColors.textTertiary),
        ],
      ),
    );
  }
}
