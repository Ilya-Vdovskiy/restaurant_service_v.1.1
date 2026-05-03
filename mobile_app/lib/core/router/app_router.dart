import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/features/article/presentation/article_view_screen.dart';
import 'package:mobile_flutter_app/features/course_detail/presentation/course_detail_screen.dart';
import 'package:mobile_flutter_app/features/courses/presentation/course_screen.dart';
import 'package:mobile_flutter_app/features/exams/presentation/exam_question_screen.dart';
import 'package:mobile_flutter_app/features/exams/presentation/exam_result_screen.dart';
import 'package:mobile_flutter_app/features/exams/presentation/exam_start_screen.dart';
import 'package:mobile_flutter_app/features/exams/presentation/exams_list_screen.dart';
import 'package:mobile_flutter_app/features/knowledge/presentation/knowledge_base_screen.dart';
import 'package:mobile_flutter_app/features/notifications/presentation/notifications_screen.dart';
import 'package:mobile_flutter_app/features/profile/presentation/profile_screen.dart';
import 'package:mobile_flutter_app/features/recipe/presentation/recipe_screen.dart';
import 'package:mobile_flutter_app/features/settings/presentation/settings_screen.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../shared/ui/navigation/app_shell.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.courses,
            name: 'courses',
            builder: (context, state) => const CourseScreen(),
          ),
          GoRoute(
            path: AppRoutes.exams,
            name: 'exams',
            builder: (context, state) => const ExamsListScreen(),
          ),
          GoRoute(
            path: AppRoutes.knowledge,
            name: 'knowledge',
            builder: (context, state) => const KnowledgeBaseScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.courseDetail,
        name: 'courseDetail',
        builder: (context, state) => const CourseDetailScreen(),
      ),
      GoRoute(
        path: AppRoutes.article,
        name: 'article',
        builder: (context, state) => const ArticleViewScreen(),
      ),
      GoRoute(
        path: AppRoutes.examStart,
        name: 'examStart',
        builder: (context, state) => const ExamStartScreen(),
      ),
      GoRoute(
        path: AppRoutes.examQuestion,
        name: 'examQuestion',
        builder: (context, state) => const ExamQuestionScreen(),
      ),
      GoRoute(
        path: AppRoutes.examResult,
        name: 'examResult',
        builder: (context, state) => const ExamResultScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipe,
        name: 'recipe',
        builder: (context, state) => const RecipeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});
