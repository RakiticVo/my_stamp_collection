import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../../app/theme/app_colors.dart';
import '../../../../domain/entities/stamp_item.dart';

class StampHero extends StatelessWidget {
  const StampHero({super.key, required this.item});

  final StampItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 380,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          image: (item.imagePath ?? '').isNotEmpty
              ? DecorationImage(
                  image: FileImage(File(item.imagePath!)),
                  fit: BoxFit.contain,
                )
              : null,
        ),
      ),
    );
  }
}
