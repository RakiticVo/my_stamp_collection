import '../../../../core/usecase/usecase.dart';
import '../entities/stamp_item.dart';
import '../repositories/collection_repository.dart';

class AddStamp implements UseCase<void, StampItem> {
  AddStamp(this._repository);

  final CollectionRepository _repository;

  @override
  Future<void> call(StampItem params) {
    return _repository.addStamp(params);
  }
}
