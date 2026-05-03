import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/buttons/primary_button.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class ExamQuestionScreen extends StatefulWidget {
  const ExamQuestionScreen({super.key});

  @override
  State<ExamQuestionScreen> createState() => _ExamQuestionScreenState();
}

class _ExamQuestionScreenState extends State<ExamQuestionScreen> {
  int selectedAnswer = -1;

  static const answers = [
    'Каждые 2 часа',
    'После каждого контакта с сырыми продуктами',
    'Только в начале смены',
    'После окончания смены',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()), title: const Text('Вопрос 1 из 12'), toolbarHeight: 72),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(value: 1 / 12, minHeight: 8, backgroundColor: AppColors.surfaceLight, valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold)),
              ),
              const SizedBox(height: 24),
              Text('Когда сотрудник обязан вымыть руки?', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              for (var i = 0; i < answers.length; i++) ...[
                _AnswerTile(text: answers[i], selected: selectedAnswer == i, onTap: () => setState(() => selectedAnswer = i)),
                const SizedBox(height: 12),
              ],
              const Spacer(),
              PrimaryButton(text: 'Ответить', onPressed: selectedAnswer == -1 ? null : () => context.push(AppRoutes.examResult)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({required this.text, required this.selected, required this.onTap});

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? AppColors.gold : AppColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
