import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/capture/presentation/pages/capture_page.dart';
import '../../features/collection/presentation/collection/pages/collection_list_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../cubit/app_tab_cubit.dart';
import '../theme/app_colors.dart';

class AppRouter {
  const AppRouter._();

  static Widget homeShell() {
    return BlocBuilder<AppTabCubit, int>(
      builder: (context, selectedTab) {
        return Scaffold(
          extendBody: true, // Allow content to scroll behind the floating nav
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: selectedTab,
            children: const [HomePage(), CapturePage(), CollectionListPage()],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: AppColors.white.withValues(alpha: 0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(
                          context,
                          icon: Icons.home_rounded,
                          label: 'Home',
                          isSelected: selectedTab == 0,
                          onTap: () => context.read<AppTabCubit>().setTab(0),
                        ),
                        _buildNavItem(
                          context,
                          icon: Icons.camera_rounded,
                          label: 'Capture',
                          isSelected: selectedTab == 1,
                          onTap: () => context.read<AppTabCubit>().setTab(1),
                        ),
                        _buildNavItem(
                          context,
                          icon: Icons.auto_awesome_mosaic_rounded,
                          label: 'Archive',
                          isSelected: selectedTab == 2,
                          onTap: () => context.read<AppTabCubit>().setTab(2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.onSurfaceVariant.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : AppColors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: -0.2,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
