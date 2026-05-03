import 'package:flutter/material.dart';
import 'package:mobile_flutter_app/features/courses/presentation/widgets/course_card.dart';
import 'package:mobile_flutter_app/features/courses/presentation/widgets/course_filter_bar.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String selectedFilter = 'В процессе';

  static const _courses = {
    'В процессе': [
      _CourseMock(
        'Винная карта 2026',
        '12 материалов • 1 тест',
        40,
        [
          CourseContentItem(type: CourseContentType.video, completed: true),
          CourseContentItem(type: CourseContentType.article, completed: true),
          CourseContentItem(type: CourseContentType.article, completed: false),
          CourseContentItem(type: CourseContentType.test, completed: false),
        ],
      ),
      _CourseMock(
        'Стандарты обслуживания',
        '8 материалов • 2 теста',
        75,
        [
          CourseContentItem(type: CourseContentType.video, completed: true),
          CourseContentItem(type: CourseContentType.article, completed: true),
          CourseContentItem(type: CourseContentType.test, completed: true),
        ],
      ),
    ],
    'Завершённые': [
      _CourseMock(
        'Работа с кассой',
        '6 материалов • 1 тест',
        100,
        [
          CourseContentItem(type: CourseContentType.video, completed: true),
          CourseContentItem(type: CourseContentType.test, completed: true),
        ],
      ),
    ],
    'Обязательные': [
      _CourseMock(
        'Санитарные нормы',
        '10 материалов • 2 теста',
        0,
        [
          CourseContentItem(type: CourseContentType.video, completed: false),
          CourseContentItem(type: CourseContentType.article, completed: false),
        ],
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final courses = _courses[selectedFilter] ?? const <_CourseMock>[];

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои курсы', style: Theme.of(context).textTheme.headlineMedium),
        toolbarHeight: 78,
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: courses.length + 1,
          separatorBuilder: (_, index) => SizedBox(height: index == 0 ? 16 : 14),
          itemBuilder: (context, index) {
            if (index == 0) {
              return CourseFilterBar(
                selectedFilter: selectedFilter,
                onFilterChanged: (filter) => setState(() => selectedFilter = filter),
              );
            }

            final course = courses[index - 1];
            return CourseCard(
              title: course.title,
              subtitle: course.subtitle,
              progress: course.progress,
              items: course.items,
            );
          },
        ),
      ),
    );
  }
}

class _CourseMock {
  const _CourseMock(this.title, this.subtitle, this.progress, this.items);

  final String title;
  final String subtitle;
  final int progress;
  final List<CourseContentItem> items;
}
