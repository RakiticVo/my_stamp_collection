import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({
    super.key,
    required this.selected,
    required this.categories,
    required this.onSelected,
  });

  final String selected;
  final List<String> categories;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.generate(categories.length, (index) {
          final String category = categories[index];
          final bool isActive = selected == category;
          return Padding(
            padding: EdgeInsets.only(
              right: index == categories.length - 1 ? 0 : 10,
            ),
            child: ChoiceChip(
              label: Text(category),
              selected: isActive,
              onSelected: (_) => onSelected(category),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isActive ? AppColors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide.none,
              backgroundColor: AppColors.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        }),
      ),
    );
  }
}
