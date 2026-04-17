import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/stamp_item.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';

class SpecimenHero extends StatelessWidget {
  const SpecimenHero({super.key, required this.item});

  final StampItem item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Perforated Border Container
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CustomPaint(
              painter: PerforationPainter(),
              child: Padding(
                padding: const EdgeInsets.all(4), // Space between perforation and content
                child: Stack(
                  children: [
                    // Main Image
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          image: (item.imagePath ?? '').isNotEmpty
                              ? DecorationImage(
                                  image: FileImage(File(item.imagePath!)),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.black.withValues(alpha: 0.1),
                                    BlendMode.darken,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    
                    // Postmark Overlay
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Opacity(
                        opacity: 0.4,
                        child: Transform.rotate(
                          angle: 0.2, // ~12 degrees
                          child: const PostmarkWidget(),
                        ),
                      ),
                    ),

                    // Label Overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              'OFFICIAL SPECIMEN',
                              style: GoogleFonts.plusJakartaSans(
                                textStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '24¢',
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                                shadows: [
                                  Shadow(color: AppColors.black.withValues(alpha: 0.26), blurRadius: 8, offset: const Offset(0, 2)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostmarkWidget extends StatelessWidget {
  const PostmarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.onSurface, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.onSurface, width: 1),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'COLLECTOR',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMM dd yyyy').format(DateTime.now()).toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 6,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PerforationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.background // Standardized color for "cutout"
      ..style = PaintingStyle.fill;

    const double radius = 6.0;
    const double spacing = 18.0;

    // Top edge
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawCircle(Offset(i + spacing / 2, 0), radius, paint);
    }
    // Bottom edge
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawCircle(Offset(i + spacing / 2, size.height), radius, paint);
    }
    // Left edge
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawCircle(Offset(0, i + spacing / 2), radius, paint);
    }
    // Right edge
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawCircle(Offset(size.width, i + spacing / 2), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
