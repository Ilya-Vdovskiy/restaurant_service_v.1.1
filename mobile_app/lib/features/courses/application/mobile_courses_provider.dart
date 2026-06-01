import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_flutter_app/core/network/api_client.dart';

final mobileCoursesProvider = FutureProvider.autoDispose<List<MobileCourse>>((
  ref,
) async {
  final data = await ref.watch(apiClientProvider).get('/mobile/courses');
  final items = data['items'] as List? ?? const [];
  return items
      .map(
        (item) => MobileCourse.fromJson(Map<String, dynamic>.from(item as Map)),
      )
      .toList();
});

class MobileCourse {
  const MobileCourse({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.progress,
    this.description,
    this.durationMinutes,
  });

  factory MobileCourse.fromJson(Map<String, dynamic> json) {
    return MobileCourse(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Курс',
      description: json['description']?.toString(),
      category: json['category']?.toString() ?? 'Обучение',
      status: json['status']?.toString() ?? 'published',
      durationMinutes: json['estimated_duration_minutes'] as int?,
      progress: json['status'] == 'completed' ? 100 : 0,
    );
  }

  final String id;
  final String title;
  final String? description;
  final String category;
  final String status;
  final int? durationMinutes;
  final int progress;

  String get subtitle {
    final duration = durationMinutes == null ? null : '${durationMinutes!} мин';
    return [category, duration].whereType<String>().join(' • ');
  }
}
