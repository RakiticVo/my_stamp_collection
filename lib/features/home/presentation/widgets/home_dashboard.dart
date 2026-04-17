import 'package:flutter/material.dart';

import 'package:my_stamp_collection/app/theme/app_colors.dart';
import 'package:my_stamp_collection/app/utils/responsive.dart';
import 'package:my_stamp_collection/features/home/domain/entities/feed_item.dart';
import 'package:my_stamp_collection/features/collection/presentation/detail/widgets/components/action_button.dart';

enum Rarity { common, rare }
enum AvatarPosition { normal, stacked }

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    super.key,
    required this.items,
    required this.query,
    required this.selectedCategory,
    required this.onQueryChanged,
    required this.onCategoryChanged,
  });

  final List<FeedItem> items;
  final String query;
  final String selectedCategory;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
      ).copyWith(bottom: 140, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context),
          SizedBox(height: Responsive.verticalSpacing(context)),
          _buildCollectionsGrid(context),
          SizedBox(height: Responsive.verticalSpacing(context)),
          _buildProgressOverview(context),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double titleSize = isMobile ? 40 : 64;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WELCOME BACK, EXPLORER',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              height: 1.1,
              letterSpacing: -1.5,
              fontFamily: 'Plus Jakarta Sans',
            ),
            children: [
              const TextSpan(text: 'Your Stampzy\n'),
              TextSpan(
                text: 'Journey',
                style: const TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildActionButton(
              icon: Icons.add_rounded,
              label: 'New Collection',
              type: ActionButtonType.primary,
            ),
            _buildActionButton(
              icon: Icons.auto_awesome_rounded,
              label: 'Daily Challenge',
              type: ActionButtonType.outline,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required ActionButtonType type}) {
    final bool isPrimary = type == ActionButtonType.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: isPrimary ? AppColors.primaryGradient : null,
        color: isPrimary ? null : AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: type == ActionButtonType.primary ? AppColors.onPrimary : AppColors.onSecondaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: type == ActionButtonType.primary ? AppColors.onPrimary : AppColors.onSecondaryContainer,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsGrid(BuildContext context) {
    final int crossAxisCount = Responsive.isMobile(context) 
        ? 1 
        : (Responsive.isTablet(context) ? 2 : 3);
    
    final List<Widget> cards = [
      _buildCollectionFeaturedCard(
        tag: 'URBAN EXPLORATION',
        title: 'Local Gems',
        image: 'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?auto=format&fit=crop&q=80&w=800',
        badge: 'LOCAL',
        stampCount: '42 Stamps',
        badgeIcon: Icons.verified_rounded,
      ),
      _buildCollectionFeaturedCard(
        tag: 'NATURE & WILDERNESS',
        title: 'Weekend Trips',
        image: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=800',
        stampCount: '18 Stamps',
      ),
      _buildCollectionFeaturedCard(
        tag: 'GLOBAL RARITIES',
        title: 'Rare Finds',
        image: 'https://images.unsplash.com/photo-1492571350019-22de08371fd3?auto=format&fit=crop&q=80&w=800',
        stampCount: '05 Stamps',
        rarity: Rarity.rare,
      ),
    ];

    if (crossAxisCount == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          cards[0],
          const SizedBox(height: 24),
          cards[1],
          const SizedBox(height: 24),
          cards[2],
        ],
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 24,
      crossAxisSpacing: 24,
      childAspectRatio: 0.85,
      children: cards,
    );
  }

  Widget _buildCollectionFeaturedCard({
    required String tag,
    required String title,
    required String image,
    required String stampCount,
    String? badge,
    IconData? badgeIcon,
    Rarity rarity = Rarity.common,
  }) {
    final bool isRare = rarity == Rarity.rare;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isGrid = constraints.maxWidth < 600; // Inside a grid cell
        
        return Container(
          height: isGrid ? null : 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.surfaceContainerLowest,
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      isRare ? AppColors.tertiary.withValues(alpha: 0.9) : AppColors.black.withValues(alpha: 0.8),
                      AppColors.transparent,
                      AppColors.transparent,
                    ],
                  ),
                ),
              ),
              if (badge != null || isRare)
                Positioned(
                  top: 24,
                  right: 24,
                  left: isRare ? 24 : null,
                  child: isRare
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.tertiary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.2), blurRadius: 8)],
                              ),
                              child: const Text('RARE', style: TextStyle(color: AppColors.onTertiary, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1.0)),
                            )
                          ],
                        )
                      : Transform.rotate(
                          angle: 0.1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.2), blurRadius: 8)],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (badgeIcon != null) ...[Icon(badgeIcon, size: 16, color: AppColors.onSecondaryContainer), const SizedBox(width: 4)],
                                if (badge != null) Text(badge, style: const TextStyle(color: AppColors.onSecondaryContainer, fontWeight: FontWeight.w800, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tag, style: TextStyle(color: AppColors.white.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                    const SizedBox(height: 4),
                    Text(title, style: const TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(stampCount, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        if (isRare)
                          const Row(
                            children: [
                              Icon(Icons.star_rounded, color: AppColors.secondary, size: 20),
                              Icon(Icons.star_rounded, color: AppColors.secondary, size: 20),
                              Icon(Icons.star_rounded, color: AppColors.secondary, size: 20),
                            ],
                          )
                        else if (badge == 'LOCAL')
                          Row(
                            children: [
                              _buildAvatarCircle(AppColors.primary),
                              _buildAvatarCircle(AppColors.primaryContainer, position: AvatarPosition.stacked),
                              _buildAvatarCircle(AppColors.secondaryContainer, position: AvatarPosition.stacked),
                            ],
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_forward_rounded, color: AppColors.white, size: 16),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarCircle(Color color, {AvatarPosition position = AvatarPosition.normal}) {
    return Transform.translate(
      offset: Offset(position == AvatarPosition.stacked ? -8.0 : 0, 0),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOTAL STAMPS', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    const Text('1,284', style: TextStyle(color: AppColors.primary, fontSize: 36, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('Top 5% of collectors', style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('COUNTRIES', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    const Text('12', style: TextStyle(color: AppColors.primary, fontSize: 36, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('Latest: Japan', style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MILESTONE', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Level 8', style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w900)),
                  Text('85%', style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: 0.85,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
