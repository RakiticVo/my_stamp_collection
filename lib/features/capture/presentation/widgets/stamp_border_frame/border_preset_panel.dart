import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';
import 'components/filter_tab_chips.dart';
import 'tabs/adjust_tab.dart';
import 'tabs/color_tab.dart';
import 'tabs/image_tab.dart';
import 'tabs/style_tab.dart';
import 'tabs/stickers_tab.dart';

class BorderPresetPanel extends StatefulWidget {
  const BorderPresetPanel({
    super.key,
    required this.editorMode,
    required this.onToggleEditorMode,
    required this.rotationDegrees,
    required this.onRotationChanged,
    required this.notchWidthScale,
    required this.onNotchWidthScaleChanged,
    required this.horizontalNotchStretch,
    required this.onHorizontalNotchStretchChanged,
    required this.selected,
    required this.onSelected,
    required this.selectedOuterShape,
    required this.onOuterShapeSelected,
    required this.selectedColorValue,
    required this.onColorSelected,
    required this.selectedImageFilter,
    required this.onImageFilterSelected,
    required this.panelExpansion,
    required this.onToggleExpanded,
  });

  final EditorMode editorMode;
  final ValueChanged<EditorMode> onToggleEditorMode;
  final double rotationDegrees;
  final ValueChanged<double> onRotationChanged;
  final double notchWidthScale;
  final ValueChanged<double> onNotchWidthScaleChanged;
  final double horizontalNotchStretch;
  final ValueChanged<double> onHorizontalNotchStretchChanged;
  final StampBorderPreset selected;
  final ValueChanged<StampBorderPreset> onSelected;
  final StampOuterShape selectedOuterShape;
  final ValueChanged<StampOuterShape> onOuterShapeSelected;
  final int? selectedColorValue;
  final ValueChanged<Color?> onColorSelected;
  final StampImageFilter selectedImageFilter;
  final ValueChanged<StampImageFilter> onImageFilterSelected;
  final PanelExpansion panelExpansion;
  final VoidCallback onToggleExpanded;

  static const List<StampBorderPreset> presets = <StampBorderPreset>[
    StampBorderPreset.classic,
    StampBorderPreset.heritage,
    StampBorderPreset.modern,
    StampBorderPreset.victorian,
    StampBorderPreset.minimal,
    StampBorderPreset.dotted,
    StampBorderPreset.plain,
  ];

  static List<Color> get palette => AppColors.stampPalette;

  @override
  State<BorderPresetPanel> createState() => _BorderPresetPanelState();
}

enum FilterTab { adjust, style, color, image, stickers }

class _BorderPresetPanelState extends State<BorderPresetPanel> {
  FilterTab _activeTab = FilterTab.style;

  @override
  Widget build(BuildContext context) {
    final Color? selectedColor = widget.selectedColorValue == null
        ? null
        : Color(widget.selectedColorValue!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: widget.onToggleExpanded,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Styles & Filters',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                Icon(
                  widget.panelExpansion == PanelExpansion.expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.onSurface,
                ),
              ],
            ),
          ),
        ),
        if (widget.panelExpansion == PanelExpansion.expanded) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterTabChip(
                  label: 'Adjust',
                  selected: _activeTab == FilterTab.adjust,
                  onTap: () => setState(() => _activeTab = FilterTab.adjust),
                ),
                const SizedBox(width: 8),
                FilterTabChip(
                  label: 'Image',
                  selected: _activeTab == FilterTab.image,
                  onTap: () => setState(() => _activeTab = FilterTab.image),
                ),
                const SizedBox(width: 8),
                FilterTabChip(
                  label: 'Border',
                  selected: _activeTab == FilterTab.style,
                  onTap: () => setState(() => _activeTab = FilterTab.style),
                ),
                const SizedBox(width: 8),
                FilterTabChip(
                  label: 'Color',
                  selected: _activeTab == FilterTab.color,
                  onTap: () => setState(() => _activeTab = FilterTab.color),
                ),
                const SizedBox(width: 8),
                FilterTabChip(
                  label: 'Stickers',
                  selected: _activeTab == FilterTab.stickers,
                  onTap: () => setState(() => _activeTab = FilterTab.stickers),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_activeTab == FilterTab.adjust) AdjustTab(widget: widget),
          if (_activeTab == FilterTab.style) StyleTab(widget: widget),
          if (_activeTab == FilterTab.color)
            ColorTab(
              widget: widget,
              selectedColor: selectedColor,
              openPicker: _openColorPickerDialog,
            ),
          if (_activeTab == FilterTab.image) ImageTab(widget: widget),
          if (_activeTab == FilterTab.stickers) const StickersTab(),
        ],
      ],
    );
  }

  Future<void> _openColorPickerDialog(
    BuildContext context,
    Color? selectedColor,
  ) async {
    Color draft = selectedColor ?? BorderPresetPanel.palette.first;

    final Color? picked = await showDialog<Color>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Pick Border Color',
            style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.onSurface),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: draft,
              onColorChanged: (Color value) => draft = value,
              enableAlpha: false,
              paletteType: PaletteType.hsvWithHue,
              hexInputBar: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w700),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(draft),
              child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );

    if (picked != null) {
      widget.onColorSelected(picked);
    }
  }
}
