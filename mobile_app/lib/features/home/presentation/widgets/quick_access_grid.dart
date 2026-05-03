import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const items = [
    _QuickAccessItem(AppRoutes.courses, Icons.menu_book_outlined, 'Мои курсы'),
    _QuickAccessItem(AppRoutes.exams, Icons.assignment_outlined, 'Экзамены'),
    _QuickAccessItem(AppRoutes.knowledge, Icons.storage_outlined, 'База знаний'),
    _QuickAccessItem(AppRoutes.profile, Icons.emoji_events_outlined, 'Результаты'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: _QuickAccessButton(item: item)),
          if (item != items.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  const _QuickAccessButton({required this.item});

  final _QuickAccessItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      onTap: () => context.go(item.path),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: AppColors.gold, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessItem {
  const _QuickAccessItem(this.path, this.icon, this.label);

  final String path;
  final IconData icon;
  final String label;
}
