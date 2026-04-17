import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_cubit.dart';
import 'package:my_stamp_collection/features/capture/presentation/cubit/capture_state.dart';

class StickersTab extends StatefulWidget {
  const StickersTab({super.key});

  @override
  State<StickersTab> createState() => _StickersTabState();
}

class _StickersTabState extends State<StickersTab> {
  Color _selectedColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stickers & Overlays',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildStickerButton(
                context,
                iconData: Icons.location_on,
                label: 'Location',
                onActive: () => _addPostmarkLoc(context),
              ),
              const SizedBox(width: 12),
              _buildStickerButton(
                context,
                iconData: Icons.verified,
                label: 'Verified',
                onActive: () => _addTextSticker(context, 'VERIFIED'),
              ),
              const SizedBox(width: 12),
              _buildStickerButton(
                context,
                iconData: Icons.auto_awesome,
                label: 'Star',
                onActive: () => _addIconSticker(context, Icons.auto_awesome),
              ),
              const SizedBox(width: 12),
              _buildStickerButton(
                context,
                iconData: Icons.favorite,
                label: 'Heart',
                onActive: () => _addIconSticker(context, Icons.favorite),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sticker Color',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildColorSelector(),
      ],
    );
  }

  Widget _buildColorSelector() {
    final colors = [
      Colors.black54,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      const Color(0xFFDAA520), // Gold
      const Color(0xFF5D1212), // Burgundy
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: colors.map((color) {
          final isSelected = _selectedColor == color;
          return GestureDetector(
            onTap: () => setState(() => _selectedColor = color),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)]
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStickerButton(
    BuildContext context, {
    required IconData iconData,
    required String label,
    required VoidCallback onActive,
  }) {
    return GestureDetector(
      onTap: onActive,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          children: [
            Icon(iconData, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _addTextSticker(BuildContext context, String text) {
    context.read<CaptureCubit>().addSticker(
          StampSticker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: text,
            color: _selectedColor,
            offset: const Offset(50, 50),
          ),
        );
  }

  void _addIconSticker(BuildContext context, IconData iconData) {
    context.read<CaptureCubit>().addSticker(
          StampSticker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            iconData: iconData,
            color: _selectedColor,
            offset: const Offset(50, 50),
          ),
        );
  }

  void _addPostmarkLoc(BuildContext context) {
    final state = context.read<CaptureCubit>().state;
    final loc = state.selectedLocation.isNotEmpty ? state.selectedLocation : 'UNKNOWN LOC';
    context.read<CaptureCubit>().addSticker(
          StampSticker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: loc.toUpperCase(),
            color: _selectedColor,
            offset: const Offset(60, 60),
            rotation: -0.2,
          ),
        );
  }
}
