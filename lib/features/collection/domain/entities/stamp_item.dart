import 'package:equatable/equatable.dart';

class StampItem extends Equatable {
  const StampItem({
    this.id,
    required this.collectionId,
    this.collectionName,
    required this.category,
    required this.title,
    required this.country,
    required this.year,
    required this.denomination,
    required this.condition,
    required this.isNft,
    this.imagePath,
    this.description,
    required this.createdAt,
  });

  final int? id;
  final int collectionId;
  final String? collectionName;
  final String category;
  final String title;
  final String country;
  final int year;
  final double denomination;
  final String condition;
  final bool isNft;
  final String? imagePath;
  final String? description;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    collectionId,
    collectionName,
    category,
    title,
    country,
    year,
    denomination,
    condition,
    isNft,
    imagePath,
    description,
    createdAt,
  ];
}

const Map<int, String> kStampCollectionNames = <int, String>{
  1: 'My Vault',
  2: 'Travel Diary',
  3: 'Rare Finds',
};

extension StampItemX on StampItem {
  String get safeCollectionName =>
      collectionName ?? kStampCollectionNames[collectionId] ?? 'My Vault';
}
