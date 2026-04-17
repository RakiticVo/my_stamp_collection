import '../entities/collection_summary.dart';
import '../entities/stamp_filter.dart';
import '../entities/stamp_item.dart';

abstract class CollectionRepository {
  Future<List<StampItem>> getStamps();

  Future<void> addStamp(StampItem stamp);

  Future<List<StampItem>> filterStamps(StampFilter filter);

  Future<List<CollectionSummary>> getCollectionSummaries();
}
