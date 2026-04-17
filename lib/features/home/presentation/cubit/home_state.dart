import 'package:equatable/equatable.dart';

import '../../domain/entities/feed_item.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.items = const [],
    this.filteredItems = const [],
    this.query = '',
    this.selectedCategory = 'All Stamps',
    this.errorMessage,
  });

  final HomeStatus status;
  final List<FeedItem> items;
  final List<FeedItem> filteredItems;
  final String query;
  final String selectedCategory;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<FeedItem>? items,
    List<FeedItem>? filteredItems,
    String? query,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    filteredItems,
    query,
    selectedCategory,
    errorMessage,
  ];
}
