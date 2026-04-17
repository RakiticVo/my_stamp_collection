import 'package:equatable/equatable.dart';

class CollectionSummary extends Equatable {
  const CollectionSummary({
    required this.id,
    required this.name,
    this.stampCount = 0,
    this.previewPaths = const <String>[],
  });

  final int id;
  final String name;
  final int stampCount;
  final List<String> previewPaths;

  @override
  List<Object?> get props => [id, name, stampCount, previewPaths];
}
