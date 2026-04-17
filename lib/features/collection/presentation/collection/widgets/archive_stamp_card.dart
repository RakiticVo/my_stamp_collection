import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';

class ArchiveStampCard extends StatelessWidget {
  const ArchiveStampCard({
    super.key,
    required this.imagePath,
    required this.location,
    required this.date,
    this.price,
    this.isLarge = false,
  });

  final String imagePath;
  final String location;
  final String date;
  final String? price;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isLarge ? 4 : 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainer,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: imagePath.startsWith('http')
                            ? Image.network(imagePath, fit: BoxFit.cover)
                            : Image.file(File(imagePath), fit: BoxFit.cover),
                      ),
                      // Perforation Holes (Simulated with Positioned circles)
                      ..._buildPerforationHoles(),
                    ],
                  ),
                ),
              ),
              if (price != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      price!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isLarge ? 12 : 8,
              horizontal: 4,
            ),
            child: Column(
              children: [
                Text(
                  location.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isLarge ? 12 : 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date.toUpperCase(),
                  style: TextStyle(
                    fontSize: isLarge ? 10 : 8,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPerforationHoles() {
    return [
      // Left side holes
      for (int i = 0; i < 6; i++)
        Positioned(
          left: -6,
          top: 20.0 + (i * 30),
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      // Right side holes
      for (int i = 0; i < 6; i++)
        Positioned(
          right: -6,
          top: 20.0 + (i * 30),
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
    ];
  }
}
