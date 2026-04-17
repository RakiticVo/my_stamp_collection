import '../../../../core/usecase/usecase.dart';
import '../entities/collection_summary.dart';
import '../repositories/collection_repository.dart';

class GetCollectionSummaries implements UseCase<List<CollectionSummary>, NoParams> {
  GetCollectionSummaries(this._repository);

  final CollectionRepository _repository;

  @override
  Future<List<CollectionSummary>> call(NoParams params) {
    return _repository.getCollectionSummaries();
  }
}
