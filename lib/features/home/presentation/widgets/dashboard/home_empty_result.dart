import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';

class HomeEmptyResult extends StatelessWidget {
  const HomeEmptyResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'No stamps match this search/category yet.',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}
