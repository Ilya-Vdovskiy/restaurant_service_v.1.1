import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class ArticleViewScreen extends StatelessWidget {
  const ArticleViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Белые и красные вина'),
        toolbarHeight: 72,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.surfaceLight, AppColors.surface],
                  ),
                ),
                child: const Center(child: Icon(Icons.article_outlined, color: AppColors.gold, size: 56)),
              ),
            ),
            const SizedBox(height: 20),
            Text('Как уверенно рекомендовать вино гостю', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text('6 минут чтения', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            const _ArticleParagraph('Начинайте с блюда, которое выбрал гость. Так рекомендация звучит естественно и помогает гостю быстрее принять решение.'),
            const _ArticleParagraph('Белые вина чаще подходят к рыбе, птице, лёгким салатам и мягким сырам. Красные вина хорошо раскрываются рядом с мясом, насыщенными соусами и выдержанными сырами.'),
            const _ArticleParagraph('Если гость сомневается, предложите два варианта: безопасный классический и более яркий авторский. Это сохраняет ощущение выбора и заботы.'),
          ],
        ),
      ),
    );
  }
}

class _ArticleParagraph extends StatelessWidget {
  const _ArticleParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
