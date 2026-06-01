import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/buttons/primary_button.dart';
import 'package:mobile_flutter_app/shared/ui/buttons/secondary_button.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events_outlined,
                        color: AppColors.gold,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Экзамен сдан',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '92%',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Вы ответили правильно на 11 из 12 вопросов',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'К экзаменам',
                onPressed: () => context.go(AppRoutes.exams),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'На главную',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
