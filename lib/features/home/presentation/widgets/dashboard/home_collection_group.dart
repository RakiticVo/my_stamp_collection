import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import 'home_dashboard_models.dart';
import 'home_place_card.dart';

class HomeCollectionGroup extends StatelessWidget {
  const HomeCollectionGroup({super.key, required this.group});

  final CollectionGroupData group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  group.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                group.actionText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 274,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: group.cards.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (_, index) => HomePlaceCard(data: group.cards[index]),
          ),
        ),
      ],
    );
  }
}
