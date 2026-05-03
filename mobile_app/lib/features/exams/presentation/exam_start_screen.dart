import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/buttons/primary_button.dart';
import 'package:mobile_flutter_app/shared/ui/buttons/secondary_button.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class ExamStartScreen extends StatelessWidget {
  const ExamStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), title: const Text('Санитарные нормы'), toolbarHeight: 72),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              AppCard(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Container(width: 72, height: 72, decoration: const BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle), child: const Icon(Icons.assignment_outlined, color: AppColors.gold, size: 36)),
                    const SizedBox(height: 18),
                    Text('Аттестация по санитарным нормам', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    Text('12 вопросов • 15 минут • проходной балл 80%', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(text: 'Начать экзамен', onPressed: () => context.push(AppRoutes.examQuestion)),
              const SizedBox(height: 12),
              SecondaryButton(text: 'Вернуться', onPressed: () => context.pop()),
            ],
          ),
        ),
      ),
    );
  }
}
