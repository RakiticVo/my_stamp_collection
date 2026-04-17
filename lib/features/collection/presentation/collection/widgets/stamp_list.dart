import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../domain/entities/stamp_item.dart';
import '../../detail/pages/stamp_detail_page.dart';

class StampList extends StatelessWidget {
  const StampList({super.key, required this.items});

  final List<StampItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final StampItem item = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StampDetailPage(item: item),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  child: _StampThumb(path: item.imagePath),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.country} · ${item.year}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('MMMM d, yyyy').format(item.createdAt),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.outline,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _Tag(
                              item.condition,
                              color: AppColors.primaryContainer,
                              textColor: AppColors.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            _Tag(
                              item.category,
                              color: AppColors.tertiaryContainer,
                              textColor: AppColors.onTertiaryContainer,
                            ),
                            if (item.isNft) ...[
                              const SizedBox(width: 8),
                              const _Tag(
                                'NFT',
                                color: AppColors.secondaryContainer,
                                textColor: AppColors.onSecondaryContainer,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StampThumb extends StatelessWidget {
  const _StampThumb({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final bool hasFile = (path ?? '').isNotEmpty && File(path!).existsSync();

    return Container(
      width: 120,
      height: 110,
      color: AppColors.surfaceContainerLowest,
      child: hasFile
          ? Image.file(File(path!), fit: BoxFit.contain)
          : const Icon(
              Icons.image_outlined,
              color: AppColors.outlineVariant,
              size: 32,
            ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, {required this.color, required this.textColor});

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
      ),
    );
  }
}
