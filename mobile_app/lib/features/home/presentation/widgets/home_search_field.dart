import 'package:flutter/material.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: AppColors.textTertiary, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Найти курс, рецепт, стандарт',
              style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
