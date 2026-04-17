import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class CaptureShutterButton extends StatefulWidget {
  const CaptureShutterButton({
    super.key,
    required this.onTap,
    this.innerColor = AppColors.secondary,
  });

  final VoidCallback onTap;
  final Color innerColor;

  @override
  State<CaptureShutterButton> createState() => _CaptureShutterButtonState();
}

class _CaptureShutterButtonState extends State<CaptureShutterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        widget.onTap();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse Ring
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryContainer.withValues(alpha: 0.2),
                  width: 4,
                ),
              ),
            ),
          ),
          // Main Button
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.26),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
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
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.innerColor,
                    border: Border.all(
                      color: widget.innerColor.withValues(alpha: 0.5),
                      width: 4,
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
