import 'package:equatable/equatable.dart';

class StampFilter extends Equatable {
  const StampFilter({
    this.query,
    this.fromYear,
    this.toYear,
    this.collectionId,
    this.category,
    this.condition,
    this.isNft,
  });

  final String? query;
  final int? fromYear;
  final int? toYear;
  final int? collectionId;
  final String? category;
  final String? condition;
  final bool? isNft;

  StampFilter copyWith({
    String? query,
    int? fromYear,
    int? toYear,
    int? collectionId,
    String? category,
    String? condition,
    bool? isNft,
  }) {
    return StampFilter(
      query: query ?? this.query,
      fromYear: fromYear ?? this.fromYear,
      toYear: toYear ?? this.toYear,
      collectionId: collectionId ?? this.collectionId,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      isNft: isNft ?? this.isNft,
    );
  }

  @override
  List<Object?> get props => [
    query,
    fromYear,
    toYear,
    collectionId,
    category,
    condition,
    isNft,
  ];
}
