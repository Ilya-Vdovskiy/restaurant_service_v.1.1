import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль', style: Theme.of(context).textTheme.headlineMedium), toolbarHeight: 78),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(child: Row(children: [
              Container(width: 64, height: 64, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.gold, width: 2), gradient: const LinearGradient(colors: [AppColors.gold, AppColors.brown]))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Александр Иванов', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 4), Text('Официант • Ресторан Premium', style: Theme.of(context).textTheme.bodyMedium)])),
            ])),
            const SizedBox(height: 16),
            Row(children: const [Expanded(child: _StatCard(value: '6', label: 'курсов')), SizedBox(width: 12), Expanded(child: _StatCard(value: '92%', label: 'средний балл'))]),
            const SizedBox(height: 16),
            _ProfileAction(icon: Icons.notifications_outlined, title: 'Уведомления', onTap: () => context.push(AppRoutes.notifications)),
            const SizedBox(height: 12),
            _ProfileAction(icon: Icons.settings_outlined, title: 'Настройки', onTap: () => context.push(AppRoutes.settings)),
            const SizedBox(height: 12),
            _ProfileAction(icon: Icons.logout, title: 'Выйти', onTap: () => context.go(AppRoutes.login)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(child: Column(children: [Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 26, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(label, style: Theme.of(context).textTheme.bodyMedium)]));
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(onTap: onTap, child: Row(children: [Icon(icon, color: AppColors.gold), const SizedBox(width: 12), Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)), const Icon(Icons.chevron_right, color: AppColors.textTertiary)]));
  }
}
