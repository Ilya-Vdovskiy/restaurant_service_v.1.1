import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/features/auth/application/auth_controller.dart';
import 'package:mobile_flutter_app/shared/ui/buttons/primary_button.dart';
import 'package:mobile_flutter_app/shared/ui/inputs/input_field.dart';

class AppLoginCard extends ConsumerStatefulWidget {
  const AppLoginCard({super.key});

  @override
  ConsumerState<AppLoginCard> createState() => _AppLoginCardState();
}

class _AppLoginCardState extends ConsumerState<AppLoginCard> {
  final _loginController = TextEditingController(
    text: 'employee@restaurant.local',
  );
  final _passwordController = TextEditingController(text: 'employee123');
  String? _error;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _error = null);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(_loginController.text.trim(), _passwordController.text);
      if (mounted) context.go(AppRoutes.home);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          'Добро пожаловать',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 56),
        InputField(
          label: 'Логин',
          hint: 'Введите логин',
          prefixIcon: Icons.person_outline,
          controller: _loginController,
        ),
        const SizedBox(height: 16),
        InputField(
          label: 'Пароль',
          hint: 'Введите пароль',
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          controller: _passwordController,
        ),
        if (_error != null) ...[
          const SizedBox(height: 14),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFB42318), fontSize: 13),
          ),
        ],
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'Войти',
          isLoading: authState.isLoading,
          onPressed: authState.isLoading ? null : _login,
        ),
        const Spacer(),
      ],
    );
  }
}
