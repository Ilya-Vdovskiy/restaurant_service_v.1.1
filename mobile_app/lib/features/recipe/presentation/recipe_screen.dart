import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), title: const Text('Техкарта'), toolbarHeight: 72),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: 170, decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(18)), gradient: LinearGradient(colors: [AppColors.surfaceLight, AppColors.surface])), child: const Center(child: Icon(Icons.ramen_dining_outlined, color: AppColors.gold, size: 58))),
                Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Паста с лососем', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8), Text('Выход: 320 г • Время: 14 минут', style: Theme.of(context).textTheme.bodyMedium)])),
              ]),
            ),
            const SizedBox(height: 18),
            _RecipeSection(title: 'Ингредиенты', lines: ['Паста — 120 г', 'Лосось — 90 г', 'Сливки 22% — 80 мл', 'Пармезан — 18 г', 'Зелень — 4 г']),
            const SizedBox(height: 14),
            _RecipeSection(title: 'Приготовление', lines: ['Отварить пасту до al dente.', 'Обжарить лосось 2 минуты.', 'Добавить сливки и пасту, прогреть.', 'Подать с пармезаном и зеленью.']),
            const SizedBox(height: 14),
            _RecipeSection(title: 'Подача', lines: ['Тарелка тёплая, край чистый.', 'Соус равномерно покрывает пасту.', 'Зелень только перед отдачей.']),
          ],
        ),
      ),
    );
  }
}

class _RecipeSection extends StatelessWidget {
  const _RecipeSection({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 12),
      for (final line in lines) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(line, style: Theme.of(context).textTheme.bodyLarge)),
    ]));
  }
}
