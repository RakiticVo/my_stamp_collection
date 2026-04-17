import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import '../border_preset_panel.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';

class ImageTab extends StatelessWidget {
  const ImageTab({super.key, required this.widget});

  final BorderPresetPanel widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image Effect',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: StampImageFilter.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final StampImageFilter filter = StampImageFilter.values[index];
              final bool isSelected = filter == widget.selectedImageFilter;

              return InkWell(
                onTap: () => widget.onImageFilterSelected(filter),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ] : null,
                  ),
                  child: Text(
                    filter.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
