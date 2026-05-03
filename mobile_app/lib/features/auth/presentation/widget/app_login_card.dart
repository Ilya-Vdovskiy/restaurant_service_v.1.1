import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_flutter_app/core/router/app_routes.dart';
import 'package:mobile_flutter_app/shared/ui/buttons/primary_button.dart';
import 'package:mobile_flutter_app/shared/ui/inputs/input_field.dart';

class AppLoginCard extends StatelessWidget {
  const AppLoginCard({super.key});

  @override
  Widget build(BuildContext context) {
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
        const InputField(
          label: 'Логин',
          hint: 'Введите логин',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        const InputField(
          label: 'Пароль',
          hint: 'Введите пароль',
          obscureText: true,
          prefixIcon: Icons.lock_outline,
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'Войти',
          onPressed: () => context.go(AppRoutes.home),
        ),
        const Spacer(),
      ],
    );
  }
}
