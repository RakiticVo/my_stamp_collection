import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/cubit/app_tab_cubit.dart';
import '../../../../../app/theme/app_colors.dart';

class CollectionEmptyState extends StatelessWidget {
  const CollectionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.collections_bookmark_outlined,
                size: 48,
                color: AppColors.outlineVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your collection is empty',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Capture your first stamp to start your journey as a collector.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.read<AppTabCubit>().setTab(1), // Switch to Capture
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Capture First Stamp'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
