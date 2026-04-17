import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';
import '../border_preset_panel.dart';

class AdjustTab extends StatelessWidget {
  const AdjustTab({super.key, required this.widget});

  final BorderPresetPanel widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Mode',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => widget.onToggleEditorMode(
            widget.editorMode == EditorMode.adjust ? EditorMode.preview : EditorMode.adjust,
          ),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: widget.editorMode == EditorMode.adjust ? AppColors.primary : AppColors.surfaceContainerLow,
              border: Border.all(
                color: widget.editorMode == EditorMode.adjust
                    ? AppColors.primary
                    : AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
              boxShadow: widget.editorMode == EditorMode.adjust ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.open_with_rounded,
                  size: 20,
                  color: widget.editorMode == EditorMode.adjust ? AppColors.white : AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.editorMode == EditorMode.adjust
                      ? 'Adjust Photo (Scroll Locked)'
                      : 'Adjust Photo',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: widget.editorMode == EditorMode.adjust
                            ? AppColors.white
                            : AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Rotation',
              style: TextStyle(
                color: AppColors.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '${widget.rotationDegrees.round()} deg',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Slider(
          value: widget.rotationDegrees.clamp(-45.0, 45.0),
          min: -45,
          max: 45,
          divisions: 90,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceContainerHigh,
          label: '${widget.rotationDegrees.round()} deg',
          onChanged: widget.onRotationChanged,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => widget.onRotationChanged(0),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Reset Rotation'),
          ),
        ),
      ],
    );
  }
}
