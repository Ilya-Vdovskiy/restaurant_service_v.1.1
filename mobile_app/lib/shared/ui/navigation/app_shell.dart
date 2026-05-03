import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _tabs = [
    _AppTab(AppRoutes.home, Icons.home_outlined, Icons.home, 'Главная'),
    _AppTab(AppRoutes.courses, Icons.menu_book_outlined, Icons.menu_book, 'Курсы'),
    _AppTab(AppRoutes.exams, Icons.assignment_outlined, Icons.assignment, 'Экзамены'),
    _AppTab(AppRoutes.knowledge, Icons.storage_outlined, Icons.storage, 'База знаний'),
    _AppTab(AppRoutes.profile, Icons.person_outline, Icons.person, 'Профиль'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.surfaceLight)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 90,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => context.go(_tabs[index].path),
              items: [
                for (final tab in _tabs)
                  BottomNavigationBarItem(
                    icon: Icon(tab.icon),
                    activeIcon: _ActiveTabIcon(icon: tab.activeIcon),
                    label: tab.label,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.path));
    return index < 0 ? 0 : index;
  }
}

class _ActiveTabIcon extends StatelessWidget {
  const _ActiveTabIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -8,
          child: Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Icon(icon),
      ],
    );
  }
}

class _AppTab {
  const _AppTab(this.path, this.icon, this.activeIcon, this.label);

  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
