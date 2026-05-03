import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class ExamsListScreen extends StatelessWidget {
  const ExamsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Экзамены', style: Theme.of(context).textTheme.headlineMedium), toolbarHeight: 78),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _ExamCard(title: 'Санитарные нормы', subtitle: '12 вопросов • 15 минут', date: 'Завтра, 10:00', urgent: true),
            const SizedBox(height: 14),
            _ExamCard(title: 'Работа с кассой', subtitle: '10 вопросов • 12 минут', date: '15 фев, 14:00', urgent: false),
            const SizedBox(height: 14),
            _ExamCard(title: 'Винная карта 2026', subtitle: '8 вопросов • 10 минут', date: 'Доступен сейчас', urgent: false),
          ],
        ),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.title, required this.subtitle, required this.date, required this.urgent});

  final String title;
  final String subtitle;
  final String date;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push(AppRoutes.examStart),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle),
            child: const Icon(Icons.assignment_outlined, color: AppColors.gold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                    if (urgent) const Text('срочно', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                Text(date, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
