import '../../domain/entities/feed_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeLocalDataSource localDataSource,
    required HomeRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final HomeLocalDataSource _localDataSource;
  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<FeedItem>> getFeed() async {
    final List<FeedItem> localItems = await _localDataSource.getLocalFeed();
    if (localItems.isNotEmpty) {
      return localItems;
    }

    return _remoteDataSource.getRemoteFeed();
  }
}
