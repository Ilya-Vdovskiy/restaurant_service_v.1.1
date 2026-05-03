import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), title: const Text('Уведомления'), toolbarHeight: 72),
      body: SafeArea(
        top: false,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: const [
          _NotificationTile(title: 'Новый обязательный курс', subtitle: 'Санитарные нормы назначены до завтра', unread: true),
          SizedBox(height: 12),
          _NotificationTile(title: 'Экзамен скоро начнётся', subtitle: 'Работа с кассой • 15 фев, 14:00', unread: true),
          SizedBox(height: 12),
          _NotificationTile(title: 'Курс завершён', subtitle: 'Стандарты сервиса успешно пройдены', unread: false),
        ]),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.title, required this.subtitle, required this.unread});

  final String title;
  final String subtitle;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return AppCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 7), decoration: BoxDecoration(color: unread ? AppColors.gold : AppColors.surfaceLight, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)])),
    ]));
  }
}
