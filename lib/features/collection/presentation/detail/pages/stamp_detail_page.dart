import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/stamp_item.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'package:my_stamp_collection/app/utils/responsive.dart';
import '../widgets/specimen_hero.dart';
import '../widgets/specimen_info_bento.dart';
import '../widgets/curator_notes_card.dart';
import '../widgets/technical_ledger_card.dart';

class StampDetailPage extends StatelessWidget {
  const StampDetailPage({super.key, required this.item});

  final StampItem item;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = Responsive.horizontalPadding(context);
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 120, horizontalPadding, 40),
            child: Column(
              children: [
                // 1. Hero Stamp Section
                SpecimenHero(item: item),
                SizedBox(height: Responsive.verticalSpacing(context)),
  
                // 2. Specimen Information (Bento)
                SpecimenInfoBento(item: item),
                const SizedBox(height: 16),
  
                // 3. Notes & Ledger (Side-by-side on large screens)
                if (isMobile) ...[
                  CuratorNotesCard(notes: item.description ?? ''),
                  const SizedBox(height: 16),
                  TechnicalLedgerCard(id: item.id.toString()),
                ] else
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: CuratorNotesCard(notes: item.description ?? ''),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: TechnicalLedgerCard(id: item.id.toString()),
                        ),
                      ],
                    ),
                  ),
                
                // Bottom spacing
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 10),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AppBar(
            backgroundColor: AppColors.background.withValues(alpha: 0.8),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
                ),
              ),
            ),
            title: Text(
              'Specimen Details',
              style: GoogleFonts.plusJakartaSans(
                textStyle: const TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            centerTitle: true,
            // Edit button removed as per user request
          ),
        ),
      ),
    );
  }
}
