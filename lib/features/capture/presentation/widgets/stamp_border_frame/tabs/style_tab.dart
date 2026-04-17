import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import '../border_preset_panel.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';

class StyleTab extends StatelessWidget {
  const StyleTab({super.key, required this.widget});

  final BorderPresetPanel widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stamp Shape',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: StampOuterShape.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final StampOuterShape shape = StampOuterShape.values[index];
              final bool isSelected = shape == widget.selectedOuterShape;
              
              String label = shape.name[0].toUpperCase() + shape.name.substring(1);

              return InkWell(
                onTap: () => widget.onOuterShapeSelected(shape),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
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
                    label,
                    style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(
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
        const SizedBox(height: 24),
        Text(
          'Stamp Border Style',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: BorderPresetPanel.presets.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final StampBorderPreset preset = BorderPresetPanel.presets[index];
              final bool isSelected = preset == widget.selected;

              return InkWell(
                onTap: () => widget.onSelected(preset),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
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
                    preset.label,
                    style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(
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
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Perforation Width',
              style: TextStyle(
                color: AppColors.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '${widget.notchWidthScale.toStringAsFixed(2)}x',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Slider(
          value: widget.notchWidthScale.clamp(0.6, 1.8),
          min: 0.6,
          max: 1.8,
          divisions: 24,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceContainerHigh,
          label: '${widget.notchWidthScale.toStringAsFixed(2)}x',
          onChanged: widget.onNotchWidthScaleChanged,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => widget.onNotchWidthScaleChanged(1),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Reset Width'),
          ),
        ),
      ],
    );
  }
}
