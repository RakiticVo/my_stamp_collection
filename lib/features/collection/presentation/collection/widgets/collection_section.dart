import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/utils/responsive.dart';
import '../../../domain/entities/collection_summary.dart';
import 'archive_stamp_card.dart';

enum CollectionLayoutType { grid, asymmetric }

class CollectionSection extends StatelessWidget {
  const CollectionSection({
    super.key,
    required this.summary,
    this.layoutType = CollectionLayoutType.grid,
    required this.onViewAll,
    required this.onStampTap,
  });

  final CollectionSummary summary;
  final CollectionLayoutType layoutType;
  final VoidCallback onViewAll;
  final Function(int) onStampTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        layoutType == CollectionLayoutType.asymmetric
            ? _buildAsymmetricLayout(context)
            : _buildGridLayout(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'COLLECTION',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              summary.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                height: 1.1,
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: onViewAll,
          icon: const Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          label: const Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: AppColors.primary,
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    final int crossAxisCount = Responsive.isMobile(context) 
        ? 2 
        : (Responsive.isTablet(context) ? 3 : 5);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.65,
      ),
      itemCount: summary.previewPaths.length.clamp(0, 4),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onStampTap(index),
          child: ArchiveStampCard(
            imagePath: summary.previewPaths[index],
            location: 'Unknown Location', // Data mapping from actual stamps would be better
            date: 'JULY 2023',
            price: index % 2 == 0 ? '€2.50' : null,
          ),
        );
      },
    );
  }

  Widget _buildAsymmetricLayout(BuildContext context) {
    final hasEnoughItems = summary.previewPaths.length >= 3;
    if (!hasEnoughItems) return _buildGridLayout(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Large main card
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => onStampTap(0),
              child: Transform.rotate(
                angle: -0.05,
                child: ArchiveStampCard(
                  imagePath: summary.previewPaths[0],
                  location: 'Feature Discovery',
                  date: 'OCT 2023',
                  price: 'RARE',
                  isLarge: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Sidebar small cards
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onStampTap(1),
                    child: ArchiveStampCard(
                      imagePath: summary.previewPaths[1],
                      location: 'Mini Trail',
                      date: 'NOV 2023',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onStampTap(2),
                    child: ArchiveStampCard(
                      imagePath: summary.previewPaths[2],
                      location: 'Meadow',
                      date: 'DEC 2023',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
