import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../domain/entities/stamp_item.dart';
import 'components/action_button.dart';
import 'components/info_tile.dart';
import 'components/stamp_hero.dart';

class StampzyCollectionRecord extends StatelessWidget {
  const StampzyCollectionRecord({
    super.key,
    required this.item,
    required this.onShare,
  });

  final StampItem item;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StampHero(item: item),
          const SizedBox(height: 28),
          Text(
            item.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                '${item.country}, ${item.year}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                _formatDate(item.createdAt),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          InfoTile(
            label: 'Collection',
            value: item.safeCollectionName,
            icon: Icons.collections_bookmark_rounded,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InfoTile(
                  label: 'Category',
                  value: item.category,
                  icon: Icons.category_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoTile(
                  label: 'Condition',
                  value: item.condition,
                  icon: Icons.verified_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ActionButton(
            title: 'Share with Collector',
            type: ActionButtonType.primary,
            onPressed: onShare,
            icon: Icons.ios_share_rounded,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[value.month - 1]} ${value.day}, ${value.year}';
  }
}
