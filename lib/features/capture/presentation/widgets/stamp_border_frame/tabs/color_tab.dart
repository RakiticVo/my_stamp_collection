import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import '../border_preset_panel.dart';
import '../components/filter_tab_chips.dart';

class ColorTab extends StatelessWidget {
  const ColorTab({
    super.key,
    required this.widget,
    required this.selectedColor,
    required this.openPicker,
  });

  final BorderPresetPanel widget;
  final Color? selectedColor;
  final Future<void> Function(BuildContext, Color?) openPicker;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Border Color',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              ColorChip(
                label: 'Auto',
                selected: selectedColor == null,
                onTap: () => widget.onColorSelected(null),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => openPicker(context, selectedColor),
                  icon: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: selectedColor ?? BorderPresetPanel.palette.first,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                  label: Text(
                    selectedColor == null ? 'Custom Picker' : 'Change Color',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
