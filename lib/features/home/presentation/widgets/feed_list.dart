import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/responsive.dart';
import '../../domain/entities/feed_item.dart';

class FeedList extends StatelessWidget {
  const FeedList({super.key, required this.items});

  final List<FeedItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final FeedItem item = items[index];
        return Card(
          color: AppColors.surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.outlineVariant, width: 1),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              child: Text(item.type.substring(0, 1).toUpperCase()),
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              item.subtitle,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}
