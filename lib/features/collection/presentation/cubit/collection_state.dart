import 'package:equatable/equatable.dart';

import '../../domain/entities/collection_summary.dart';
import '../../domain/entities/stamp_filter.dart';
import '../../domain/entities/stamp_item.dart';

enum CollectionStatus { initial, loading, loaded, error }

class CollectionState extends Equatable {
  const CollectionState({
    this.status = CollectionStatus.initial,
    this.collections = const [],
    this.items = const [],
    this.filteredItems = const [],
    this.availableCategories = const [],
    this.selectedCollectionId,
    this.selectedCategory,
    this.filter = const StampFilter(),
    this.errorMessage,
  });

  final CollectionStatus status;
  final List<CollectionSummary> collections;
  final List<StampItem> items;
  final List<StampItem> filteredItems;
  final List<String> availableCategories;
  final int? selectedCollectionId;
  final String? selectedCategory;
  final StampFilter filter;
  final String? errorMessage;

  CollectionState copyWith({
    CollectionStatus? status,
    List<CollectionSummary>? collections,
    List<StampItem>? items,
    List<StampItem>? filteredItems,
    List<String>? availableCategories,
    int? selectedCollectionId,
    String? selectedCategory,
    StampFilter? filter,
    String? errorMessage,
  }) {
    return CollectionState(
      status: status ?? this.status,
      collections: collections ?? this.collections,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      availableCategories: availableCategories ?? this.availableCategories,
      selectedCollectionId: selectedCollectionId ?? this.selectedCollectionId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        collections,
        items,
        filteredItems,
        availableCategories,
        selectedCollectionId,
        selectedCategory,
        filter,
        errorMessage,
      ];
}
