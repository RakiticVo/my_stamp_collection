import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/collection_summary.dart';
import '../../domain/entities/stamp_filter.dart';
import '../../domain/entities/stamp_item.dart';
import '../../domain/usecases/filter_stamps.dart';
import '../../domain/usecases/get_collection_summaries.dart';
import '../../domain/usecases/get_stamps.dart';
import 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit({
    required GetStamps getStamps,
    required GetCollectionSummaries getCollectionSummaries,
    required FilterStamps filterStamps,
  }) : _getStamps = getStamps,
       _getCollectionSummaries = getCollectionSummaries,
       _filterStamps = filterStamps,
       super(const CollectionState());

  final GetStamps _getStamps;
  final GetCollectionSummaries _getCollectionSummaries;
  final FilterStamps _filterStamps;

  /// Loads all collection summaries for the main list screen.
  Future<void> loadCollections() async {
    emit(state.copyWith(status: CollectionStatus.loading));
    try {
      final List<CollectionSummary> summaries = await _getCollectionSummaries(const NoParams());
      emit(state.copyWith(
        status: CollectionStatus.loaded,
        collections: summaries,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CollectionStatus.error,
        errorMessage: 'Unable to load collections: $error',
      ));
    }
  }

  /// Loads all stamps for a specific collection and prepares inline categories.
  Future<void> loadStampsForCollection(int collectionId) async {
    emit(state.copyWith(
      status: CollectionStatus.loading,
      selectedCollectionId: collectionId,
      selectedCategory: null, // Reset category filter when switching collections
    ));
    try {
      // For now, we load all and filter in memory since the DB query is already optimized
      // and the collection size is manageable.
      final List<StampItem> allStamps = await _getStamps(const NoParams());
      final List<StampItem> collectionStamps = allStamps.where((s) => s.collectionId == collectionId).toList();
      
      final List<String> categories = collectionStamps
          .map((s) => s.category)
          .toSet()
          .toList()
        ..sort();

      emit(state.copyWith(
        status: CollectionStatus.loaded,
        items: collectionStamps,
        filteredItems: collectionStamps,
        availableCategories: categories,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CollectionStatus.error,
        errorMessage: 'Unable to load stamps: $error',
      ));
    }
  }

  /// Filters the current collection by category.
  void selectCategory(String? category) {
    if (state.selectedCategory == category) return;

    final List<StampItem> filtered = _filterStamps.applyInMemory(
      source: state.items,
      filter: StampFilter(category: category),
    );

    emit(state.copyWith(
      selectedCategory: category,
      filteredItems: filtered,
    ));
  }
}
