import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/stamp_item.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'package:my_stamp_collection/app/utils/responsive.dart';

class SpecimenInfoBento extends StatelessWidget {
  const SpecimenInfoBento({super.key, required this.item});

  final StampItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Specimen Information',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Responsive.isMobile(context) && MediaQuery.sizeOf(context).width < 450
              ? Column(
                  children: [
                    _buildInfoItem('Date Captured', DateFormat('MMMM dd, yyyy').format(item.createdAt)),
                    const SizedBox(height: 16),
                    _buildInfoItem('Location', item.country),
                    const SizedBox(height: 16),
                    _buildInfoItem('Collection', item.safeCollectionName, isPrimary: true),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildInfoItem('Date Captured', DateFormat('MMMM dd, yyyy').format(item.createdAt))),
                    Expanded(child: _buildInfoItem('Location', item.country)),
                    Expanded(child: _buildInfoItem('Collection', item.safeCollectionName, isPrimary: true)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isPrimary ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
