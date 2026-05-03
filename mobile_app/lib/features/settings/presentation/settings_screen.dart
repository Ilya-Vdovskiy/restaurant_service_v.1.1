import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';
import 'package:mobile_flutter_app/shared/ui/cards/app_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool sounds = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), title: const Text('Настройки'), toolbarHeight: 72),
      body: SafeArea(
        top: false,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
          AppCard(child: Column(children: [
            _SwitchRow(title: 'Push-уведомления', value: notifications, onChanged: (value) => setState(() => notifications = value)),
            const Divider(color: AppColors.surfaceLight),
            _SwitchRow(title: 'Звуки', value: sounds, onChanged: (value) => setState(() => sounds = value)),
          ])),
          const SizedBox(height: 14),
          AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Версия приложения', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 6), Text('1.0.0 • mock build', style: Theme.of(context).textTheme.bodyMedium)])),
        ]),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.title, required this.value, required this.onChanged});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)), Switch(value: value, activeColor: AppColors.gold, onChanged: onChanged)]);
  }
}
