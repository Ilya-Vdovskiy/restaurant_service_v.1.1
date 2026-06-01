import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_flutter_app/features/courses/application/mobile_courses_provider.dart';
import 'package:mobile_flutter_app/features/courses/presentation/widgets/course_card.dart';
import 'package:mobile_flutter_app/features/courses/presentation/widgets/course_filter_bar.dart';

class CourseScreen extends ConsumerStatefulWidget {
  const CourseScreen({super.key});

  @override
  ConsumerState<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
  String selectedFilter = 'В процессе';

  @override
  Widget build(BuildContext context) {
    final coursesState = ref.watch(mobileCoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Мои курсы',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        toolbarHeight: 78,
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(mobileCoursesProvider.future),
          child: coursesState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                CourseFilterBar(
                  selectedFilter: selectedFilter,
                  onFilterChanged: (filter) =>
                      setState(() => selectedFilter = filter),
                ),
                const SizedBox(height: 24),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFB42318)),
                ),
              ],
            ),
            data: (items) {
              final courses = _filterCourses(items);

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: courses.isEmpty ? 2 : courses.length + 1,
                separatorBuilder: (_, index) =>
                    SizedBox(height: index == 0 ? 16 : 14),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return CourseFilterBar(
                      selectedFilter: selectedFilter,
                      onFilterChanged: (filter) =>
                          setState(() => selectedFilter = filter),
                    );
                  }

                  if (courses.isEmpty) {
                    return const _EmptyCourses();
                  }

                  final course = courses[index - 1];
                  return CourseCard(
                    title: course.title,
                    subtitle: course.subtitle,
                    progress: course.progress,
                    items: const [
                      CourseContentItem(
                        type: CourseContentType.article,
                        completed: false,
                      ),
                      CourseContentItem(
                        type: CourseContentType.test,
                        completed: false,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<MobileCourse> _filterCourses(List<MobileCourse> courses) {
    return switch (selectedFilter) {
      'Завершённые' =>
        courses.where((course) => course.progress >= 100).toList(),
      'Обязательные' => courses,
      _ => courses.where((course) => course.progress < 100).toList(),
    };
  }
}

class _EmptyCourses extends StatelessWidget {
  const _EmptyCourses();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 56),
      child: Text('Назначенных курсов пока нет', textAlign: TextAlign.center),
    );
  }
}
