import '../models/feed_item_model.dart';

class HomeLocalDataSource {
  Future<List<FeedItemModel>> getLocalFeed() async {
    return const [
      FeedItemModel(
        id: 'news-001',
        title: 'WNS Update 2026',
        subtitle: 'Regional stamp standards refreshed for digital archives.',
        type: 'news',
        category: 'Architecture',
      ),
      FeedItemModel(
        id: 'trend-001',
        title: 'Trending: Space Exploration Series',
        subtitle: 'Collectors are actively trading this series this week.',
        type: 'trending',
        category: 'Landmarks',
      ),
      FeedItemModel(
        id: 'release-001',
        title: 'New Release: Lunar New Year',
        subtitle: 'High-resolution commemorative set now available.',
        type: 'release',
        category: 'Nature',
      ),
    ];
  }
}
