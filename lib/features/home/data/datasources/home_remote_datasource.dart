import '../../../../core/network/api_client.dart';
import '../models/feed_item_model.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FeedItemModel>> getRemoteFeed() async {
    // Reserved for future remote API integration.
    final _ = _apiClient.instance;
    return const [];
  }
}
