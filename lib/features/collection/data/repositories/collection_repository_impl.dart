import '../../domain/entities/collection_summary.dart';
import '../../domain/entities/stamp_filter.dart';
import '../../domain/entities/stamp_item.dart';
import '../../domain/repositories/collection_repository.dart';
import '../datasources/collection_local_datasource.dart';
import '../models/stamp_item_model.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  CollectionRepositoryImpl(this._localDataSource);

  final CollectionLocalDataSource _localDataSource;

  @override
  Future<void> addStamp(StampItem stamp) {
    return _localDataSource.addStamp(StampItemModel.fromEntity(stamp));
  }

  @override
  Future<List<StampItem>> filterStamps(StampFilter filter) {
    return _localDataSource.filterStamps(filter);
  }

  @override
  Future<List<StampItem>> getStamps() {
    return _localDataSource.getStamps();
  }

  @override
  Future<List<CollectionSummary>> getCollectionSummaries() {
    return _localDataSource.getCollectionSummaries();
  }
}
