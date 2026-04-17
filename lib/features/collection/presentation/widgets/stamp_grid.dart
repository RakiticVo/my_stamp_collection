import 'package:flutter/material.dart';

import '../../domain/entities/stamp_item.dart';

class StampGrid extends StatelessWidget {
  const StampGrid({super.key, required this.items});

  final List<StampItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No stamps yet. Add one from Capture.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final StampItem item = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text('${item.country} • ${item.year}'),
                const Spacer(),
                Text('Denomination: ${item.denomination.toStringAsFixed(0)}'),
                Text('Condition: ${item.condition}'),
                Text(item.isNft ? 'NFT: Yes' : 'NFT: No'),
              ],
            ),
          ),
        );
      },
    );
  }
}
