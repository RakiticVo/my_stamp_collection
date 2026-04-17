import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../cubit/capture_cubit.dart';
import 'package:camera/camera.dart';

class CaptureHeader extends StatelessWidget {
  const CaptureHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.8),
          padding: const EdgeInsets.all(12),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.menu_rounded,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Stampzy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildFlashToggle(context),
                    const SizedBox(width: 4),
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerHigh,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 2),
                        image: const DecorationImage(
                          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBUo3j5q3WLXKjccN-fkX0GffQ1m5ferhsSZ2fK1YLlE_Sfj47Xyw88MTSHlO3cX5XmQeGOTdEqxUuQ_PcYbENalv4ZtCae712cXIF6lertbIw_gZ4wNycGLr10aB8Fm5Iphbss9NtfQlhaK0LA_tvT_GhFxf25J0qESYQw_YR799gVglxNGSUsVtd0xBte-n0lhuGZ7XODp8IUZmkmHnIejB6xQiyNRZMEUPCuClfi4I7BV7QzzFDvH-qUax3aZWOZMxLmtj2Ig4L-'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlashToggle(BuildContext context) {
    final cubit = context.read<CaptureCubit>();
    final flashMode = context.select((CaptureCubit c) => c.state.flashMode);

    IconData getIcon() {
      switch (flashMode) {
        case FlashMode.off: return Icons.flash_off_rounded;
        case FlashMode.always: return Icons.flash_on_rounded;
        case FlashMode.auto: return Icons.flash_auto_rounded;
        case FlashMode.torch: return Icons.highlight_rounded;
      }
    }

    return IconButton(
      onPressed: cubit.toggleFlash,
      icon: Icon(getIcon(), color: AppColors.primary),
    );
  }
}
