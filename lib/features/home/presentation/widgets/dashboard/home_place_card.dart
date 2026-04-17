import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/utils/responsive.dart';
import 'home_dashboard_models.dart';

class HomePlaceCard extends StatelessWidget {
  const HomePlaceCard({super.key, required this.data});

  final PlaceCardData data;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    
    return SizedBox(
      width: isMobile ? 260 : 320,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.surfaceContainerLowest,
          border: Border.all(color: AppColors.surfaceContainerHigh, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isMobile ? 300 : 360,
                width: double.infinity,
                color: AppColors.surfaceContainer,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      data.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Container(color: AppColors.surfaceContainerHighest),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.black.withValues(alpha: 0.7),
                            AppColors.transparent,
                            AppColors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  data.date.toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.white.withValues(alpha: 1.0),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: 1.0),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.secondary, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  data.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.white.withValues(alpha: 0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
