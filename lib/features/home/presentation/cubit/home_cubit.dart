import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/feed_item.dart';
import '../../domain/usecases/get_home_feed.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeFeed) : super(const HomeState());

  final GetHomeFeed _getHomeFeed;
  static const String allStampsCategory = 'All Stamps';

  Future<void> loadFeed() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final items = await _getHomeFeed(const NoParams());
      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          items: items,
          filteredItems: items,
          query: '',
          selectedCategory: allStampsCategory,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Unable to load home feed: $error',
        ),
      );
    }
  }

  void updateQuery(String value) {
    emit(state.copyWith(query: value));
    _applyFilters();
  }

  void updateCategory(String value) {
    emit(state.copyWith(selectedCategory: value));
    _applyFilters();
  }

  void _applyFilters() {
    final String query = state.query.trim().toLowerCase();
    final String selectedCategory = state.selectedCategory;

    final List<FeedItem> filtered = state.items
        .where((item) {
          final bool matchesCategory =
              selectedCategory == allStampsCategory ||
              item.category.toLowerCase() == selectedCategory.toLowerCase();

          final bool matchesQuery =
              query.isEmpty ||
              item.title.toLowerCase().contains(query) ||
              item.subtitle.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query);

          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);

    emit(state.copyWith(filteredItems: filtered));
  }
}
