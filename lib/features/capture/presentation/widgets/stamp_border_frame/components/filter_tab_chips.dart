import 'package:flutter/material.dart';
import '../../../../../../app/theme/app_colors.dart';

class FilterTabChip extends StatelessWidget {
  const FilterTabChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: selected ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? AppColors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? AppColors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}
