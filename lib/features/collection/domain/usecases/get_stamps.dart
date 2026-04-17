import '../../../../core/usecase/usecase.dart';
import '../entities/stamp_item.dart';
import '../repositories/collection_repository.dart';

class GetStamps implements UseCase<List<StampItem>, NoParams> {
  GetStamps(this._repository);

  final CollectionRepository _repository;

  @override
  Future<List<StampItem>> call(NoParams params) {
    return _repository.getStamps();
  }
}
