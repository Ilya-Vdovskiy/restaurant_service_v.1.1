import 'package:flutter/material.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';
import 'package:mobile_flutter_app/shared/ui/progress/app_circular_progress.dart';

class ProgressBlock extends StatelessWidget {
  const ProgressBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Мой прогресс', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 18),
          const Row(
            children: [
              AppCircularProgress(value: 0.6),
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProgressLine(text: 'Назначено ', accent: '4 курса'),
                    SizedBox(height: 6),
                    _ProgressLine(text: 'На этой неделе ', accent: '2 теста'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.text, required this.accent});

  final String text;
  final String accent;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: text),
          TextSpan(
            text: accent,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
