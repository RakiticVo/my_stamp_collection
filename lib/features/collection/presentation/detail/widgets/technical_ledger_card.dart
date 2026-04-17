import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';

class TechnicalLedgerCard extends StatelessWidget {
  const TechnicalLedgerCard({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    // Mock Catalog No: SZ-2026-0001 (based on ID)
    final String catalogNo = 'SZ-2026-${id.padLeft(4, '0')}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TECHNICAL LEDGER',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildLedgerRow('Catalog No', catalogNo, isMono: true),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _buildLedgerRow('Rarity Grade', 'Limited Edition', isRarity: true),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
              child: Text(
                'View in Album',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerRow(String label, String value, {bool isMono = false, bool isRarity = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (isRarity)
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.tertiary, size: 14),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  textStyle: isMono ? const TextStyle(fontFamily: 'monospace') : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
