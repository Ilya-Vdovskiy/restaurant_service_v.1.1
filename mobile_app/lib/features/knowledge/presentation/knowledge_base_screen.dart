import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class KnowledgeBaseScreen extends StatelessWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('База знаний', style: Theme.of(context).textTheme.headlineMedium), toolbarHeight: 78),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
              child: const Row(children: [Icon(Icons.search, color: AppColors.textTertiary), SizedBox(width: 12), Text('Найти рецепт, стандарт, инструкцию', style: TextStyle(color: AppColors.textTertiary))]),
            ),
            const SizedBox(height: 18),
            _KnowledgeTile(icon: Icons.restaurant_menu_outlined, title: 'Техкарты блюд', subtitle: 'Рецепты, граммовки и подача', onTap: () => context.push(AppRoutes.recipe)),
            const SizedBox(height: 12),
            _KnowledgeTile(icon: Icons.room_service_outlined, title: 'Стандарты сервиса', subtitle: 'Правила общения с гостем', onTap: () {}),
            const SizedBox(height: 12),
            _KnowledgeTile(icon: Icons.clean_hands_outlined, title: 'Санитарные нормы', subtitle: 'Чистота, хранение, маркировка', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _KnowledgeTile extends StatelessWidget {
  const _KnowledgeTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(children: [
        Container(width: 46, height: 46, decoration: const BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle), child: Icon(icon, color: AppColors.gold)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)])),
        const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      ]),
    );
  }
}
