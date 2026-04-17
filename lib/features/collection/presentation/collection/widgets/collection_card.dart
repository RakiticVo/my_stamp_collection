import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import 'package:my_stamp_collection/features/collection/domain/entities/collection_summary.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.summary,
    required this.onTap,
  });

  final CollectionSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surfaceContainerHigh, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Image(s)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: summary.previewPaths.isNotEmpty
                    ? Container(
                        color: AppColors.surfaceContainer,
                        child: _buildPreview(summary.previewPaths),
                      )
                    : Container(
                        color: AppColors.surfaceContainerHigh,
                        child: Icon(
                          Icons.collections_bookmark_outlined,
                          size: 48,
                          color: AppColors.outlineVariant.withValues(alpha: 0.6),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.name,
                          style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: AppColors.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${summary.stampCount} stamps',
                            style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.outline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(List<String> paths) {
    if (paths.length == 1) {
      return Image.file(File(paths[0]), fit: BoxFit.cover);
    }

    // Mosaic for 2 or 3 images
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: AppColors.surfaceContainer,
            child: Image.file(File(paths[0]), fit: BoxFit.cover),
          ),
        ),
        if (paths.length > 1) ...[
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.surfaceContainer,
                    child: Image.file(File(paths[1]), fit: BoxFit.cover),
                  ),
                ),
                if (paths.length > 2) ...[
                  const SizedBox(height: 2),
                  Expanded(
                    child: Container(
                      color: AppColors.surfaceContainer,
                      child: Image.file(File(paths[2]), fit: BoxFit.cover),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
