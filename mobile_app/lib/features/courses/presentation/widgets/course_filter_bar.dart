import 'package:flutter/material.dart';
import 'package:mobile_flutter_app/core/theme/app_colors.dart';

class CourseFilterBar extends StatelessWidget {
  const CourseFilterBar({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  static const filters = [
    'В процессе',
    'Завершённые',
    'Обязательные',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          for (final filter in filters)
            Expanded(
              child: _CourseFilterTab(
                text: filter,
                isSelected: filter == selectedFilter,
                onTap: () => onFilterChanged(filter),
              ),
            ),
        ],
      ),
    );
  }
}

class _CourseFilterTab extends StatelessWidget {
  const _CourseFilterTab({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? AppColors.background : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
