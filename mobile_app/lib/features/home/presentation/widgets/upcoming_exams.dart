import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/badges/app_badge.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class UpcomingExams extends StatelessWidget {
  const UpcomingExams({super.key});

  static const exams = [
    _ExamPreview('Санитарные нормы', 'Завтра, 10:00', true),
    _ExamPreview('Работа с кассой', '15 фев, 14:00', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final exam in exams) ...[
          AppCard(
            onTap: () => context.go(AppRoutes.exams),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: AppColors.gold,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exam.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: AppColors.textSecondary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(exam.date, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                if (exam.isUrgent) ...[
                  const SizedBox(width: 8),
                  const AppBadge(text: 'срочно', color: Color(0xFFDC2626)),
                ],
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ),
          if (exam != exams.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ExamPreview {
  const _ExamPreview(this.title, this.date, this.isUrgent);

  final String title;
  final String date;
  final bool isUrgent;
}
