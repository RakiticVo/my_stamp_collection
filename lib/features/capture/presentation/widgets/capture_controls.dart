import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class CaptureControls extends StatefulWidget {
  const CaptureControls({
    super.key,
    required this.loading,
    required this.onSnap,
    required this.onGallery,
    this.onFiltersPressed,
  });

  final bool loading;
  final VoidCallback onSnap;
  final VoidCallback onGallery;
  final VoidCallback? onFiltersPressed;

  @override
  State<CaptureControls> createState() => _CaptureControlsState();
}

class _CaptureControlsState extends State<CaptureControls>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Gallery Button
          _buildSideButton(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            onTap: widget.loading ? null : widget.onGallery,
          ),

          // Shutter Button
          _buildShutterButton(),

          // Filters Button
          _buildSideButton(
            icon: Icons.auto_fix_high,
            iconColor: AppColors.primary,
            label: 'Filters',
            onTap: widget.loading ? null : widget.onFiltersPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLow,
              border: Border.all(color: AppColors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor ?? AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: widget.loading ? null : widget.onSnap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse ring
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 112 + (_pulseController.value * 12),
                height: 112 + (_pulseController.value * 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryContainer.withValues(
                        alpha: 0.2 * (1 - _pulseController.value)),
                    width: 4,
                  ),
                ),
              );
            },
          ),
          // Main Shutter
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryContainer],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.26),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.2),
                  width: 6,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(10), // white gap
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Center(
                  child: widget.loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.secondary,
                          ),
                        )
                      : Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary,
                            border: Border.all(
                              color: AppColors.secondaryContainer,
                              width: 4,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
