import 'package:flutter/material.dart';
import 'package:mobile_flutter_app/features/auth/presentation/widget/app_login_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: const AppLoginCard(),
        ),
      ),
    );
  }
}
