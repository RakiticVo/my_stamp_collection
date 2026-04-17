import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';

class CuratorNotesCard extends StatelessWidget {
  const CuratorNotesCard({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Geometric decoration
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_note_rounded, color: AppColors.secondary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'CURATOR\'S NOTES',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                notes.isEmpty ? '"No notes recorded for this specimen."' : '"$notes"',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
