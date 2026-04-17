import '../entities/feed_item.dart';

abstract class HomeRepository {
  Future<List<FeedItem>> getFeed();
}
