import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../cubit/collection_cubit.dart';
import '../../cubit/collection_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/stamp_list.dart';

class CollectionStampsPage extends StatefulWidget {
  const CollectionStampsPage({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  final int collectionId;
  final String collectionName;

  @override
  State<CollectionStampsPage> createState() => _CollectionStampsPageState();
}

class _CollectionStampsPageState extends State<CollectionStampsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionCubit>().loadStampsForCollection(widget.collectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.collectionName),
      ),
      body: SafeArea(
        child: Column(
          children: [
          const SizedBox(height: 8),
          BlocBuilder<CollectionCubit, CollectionState>(
            buildWhen: (previous, current) =>
                previous.availableCategories != current.availableCategories ||
                previous.selectedCategory != current.selectedCategory,
            builder: (context, state) {
              if (state.availableCategories.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CategoryFilterBar(
                  categories: state.availableCategories,
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (category) =>
                      context.read<CollectionCubit>().selectCategory(category),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<CollectionCubit, CollectionState>(
              builder: (context, state) {
                if (state.status == CollectionStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == CollectionStatus.error) {
                  return Center(
                    child: Text(state.errorMessage ?? 'Error occurred'),
                  );
                }

                if (state.filteredItems.isEmpty) {
                  return const Center(
                    child: Text('No stamps found in this category.'),
                  );
                }

                return StampList(items: state.filteredItems);
              },
            ),
          ),
        ],
      ),
    ));
  }
}
