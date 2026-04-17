import '../../../../core/usecase/usecase.dart';
import '../entities/stamp_filter.dart';
import '../entities/stamp_item.dart';
import '../repositories/collection_repository.dart';

class FilterStamps implements UseCase<List<StampItem>, StampFilter> {
  FilterStamps([this._repository]);

  final CollectionRepository? _repository;

  @override
  Future<List<StampItem>> call(StampFilter params) {
    if (_repository == null) {
      return Future.value(<StampItem>[]);
    }
    return _repository.filterStamps(params);
  }

  List<StampItem> applyInMemory({
    required List<StampItem> source,
    required StampFilter filter,
  }) {
    final String query = (filter.query ?? '').trim().toLowerCase();

    return source
        .where((StampItem stamp) {
          final bool matchesQuery =
              query.isEmpty ||
              stamp.title.toLowerCase().contains(query) ||
              stamp.country.toLowerCase().contains(query);
          final bool matchesFromYear =
              filter.fromYear == null || stamp.year >= filter.fromYear!;
          final bool matchesToYear =
              filter.toYear == null || stamp.year <= filter.toYear!;
          final bool matchesCollection =
              filter.collectionId == null ||
              stamp.collectionId == filter.collectionId;
          final bool matchesCategory =
              filter.category == null ||
              filter.category!.isEmpty ||
              stamp.category == filter.category;
          final bool matchesCondition =
              filter.condition == null ||
              filter.condition!.isEmpty ||
              stamp.condition == filter.condition;
          final bool matchesNft =
              filter.isNft == null || stamp.isNft == filter.isNft;

          return matchesQuery &&
              matchesFromYear &&
              matchesToYear &&
              matchesCollection &&
              matchesCategory &&
              matchesCondition &&
              matchesNft;
        })
        .toList(growable: false);
  }
}
