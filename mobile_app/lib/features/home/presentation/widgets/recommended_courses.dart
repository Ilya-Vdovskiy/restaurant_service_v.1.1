import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/badges/app_badge.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class RecommendedCourses extends StatelessWidget {
  const RecommendedCourses({super.key});

  static const courses = [
    _CoursePreview('Винная карта 2026', true),
    _CoursePreview('Стандарты сервиса', false),
    _CoursePreview('Новое меню', true),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 206,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final course = courses[index];

          return SizedBox(
            width: 248,
            child: AppCard(
              padding: EdgeInsets.zero,
              onTap: () => context.go(AppRoutes.courses),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 104,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.surfaceLight, AppColors.surface],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.menu_book_outlined,
                        color: AppColors.gold,
                        size: 40,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              course.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (course.isNew) ...[
                            const SizedBox(width: 8),
                            const AppBadge(text: 'новинка'),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CoursePreview {
  const _CoursePreview(this.title, this.isNew);

  final String title;
  final bool isNew;
}
