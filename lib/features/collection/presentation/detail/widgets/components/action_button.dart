import 'package:flutter/material.dart';
import '../../../../../../app/theme/app_colors.dart';

enum ActionButtonType { primary, outline }

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.title,
    required this.type,
    required this.onPressed,
    this.icon,
  });

  final String title;
  final ActionButtonType type;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
    );

    if (type == ActionButtonType.primary) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
          label: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          style: style.copyWith(
            backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
            foregroundColor: const WidgetStatePropertyAll(AppColors.white),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
        label: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          foregroundColor: AppColors.primary,
        ),
      ),
    );
  }
}
