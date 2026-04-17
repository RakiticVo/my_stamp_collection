import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All"
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final bool isAll = index == 0;
          final String label = isAll ? 'All' : categories[index - 1];
          final String? value = isAll ? null : label;
          final bool isSelected = selectedCategory == value;

          return _FilterChip(
            label: label,
            isSelected: isSelected,
            onTap: () => onCategorySelected(value),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.primary : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? AppColors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
