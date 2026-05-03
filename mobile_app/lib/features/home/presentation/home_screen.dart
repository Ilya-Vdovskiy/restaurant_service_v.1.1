import 'package:flutter/material.dart';
import 'package:mobile_flutter_app/features/home/presentation/widgets/home_header.dart';
import 'package:mobile_flutter_app/features/home/presentation/widgets/home_search_field.dart';
import 'package:mobile_flutter_app/features/home/presentation/widgets/home_section_title.dart';
import 'package:mobile_flutter_app/features/home/presentation/widgets/progress_block.dart';
import 'package:mobile_flutter_app/features/home/presentation/widgets/quick_access_grid.dart';
import 'package:mobile_flutter_app/features/home/presentation/widgets/recommended_courses.dart';
import 'package:mobile_flutter_app/features/home/presentation/widgets/upcoming_exams.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({this.title = 'Главная', super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    if (title != 'Главная') {
      return _PlaceholderScreen(title: title);
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
          children: [
            HomeHeader(),
            SizedBox(height: 24),
            HomeSearchField(),
            SizedBox(height: 24),
            ProgressBlock(),
            SizedBox(height: 24),
            QuickAccessGrid(),
            SizedBox(height: 24),
            HomeSectionTitle(title: 'Рекомендуем вам'),
            SizedBox(height: 12),
            RecommendedCourses(),
            SizedBox(height: 24),
            HomeSectionTitle(title: 'Предстоящие экзамены'),
            SizedBox(height: 12),
            UpcomingExams(),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AppCard(
            child: Text(
              'Пустой экран. Наполним его на следующих шагах.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
