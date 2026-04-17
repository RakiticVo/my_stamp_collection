import 'package:flutter/material.dart';
import '../../../../../../app/theme/app_colors.dart';

class TagChip extends StatelessWidget {
  const TagChip(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
