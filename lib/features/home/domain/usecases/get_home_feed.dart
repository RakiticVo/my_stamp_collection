import '../../../../core/usecase/usecase.dart';
import '../entities/feed_item.dart';
import '../repositories/home_repository.dart';

class GetHomeFeed implements UseCase<List<FeedItem>, NoParams> {
  GetHomeFeed(this._repository);

  final HomeRepository _repository;

  @override
  Future<List<FeedItem>> call(NoParams params) {
    return _repository.getFeed();
  }
}
