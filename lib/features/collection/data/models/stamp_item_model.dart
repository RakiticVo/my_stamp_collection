import '../../domain/entities/stamp_item.dart';

class StampItemModel extends StampItem {
  const StampItemModel({
    super.id,
    required super.collectionId,
    super.collectionName,
    required super.category,
    required super.title,
    required super.country,
    required super.year,
    required super.denomination,
    required super.condition,
    required super.isNft,
    super.imagePath,
    super.description,
    required super.createdAt,
  });

  factory StampItemModel.fromMap(Map<String, Object?> map) {
    return StampItemModel(
      id: map['id'] as int?,
      collectionId: map['collection_id'] as int,
      collectionName: map['collection_name'] as String?,
      category: (map['category'] as String?) ?? 'General',
      title: map['title'] as String,
      country: map['country'] as String,
      year: map['year'] as int,
      denomination: (map['denomination'] as num).toDouble(),
      condition: map['condition'] as String,
      isNft: (map['is_nft'] as int) == 1,
      imagePath: map['image_path'] as String?,
      description: map['description'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'collection_id': collectionId,
      'category': category,
      'title': title,
      'country': country,
      'year': year,
      'denomination': denomination,
      'condition': condition,
      'is_nft': isNft ? 1 : 0,
      'image_path': imagePath,
      'description': description,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory StampItemModel.fromEntity(StampItem item) {
    return StampItemModel(
      id: item.id,
      collectionId: item.collectionId,
      collectionName: item.collectionName,
      category: item.category,
      title: item.title,
      country: item.country,
      year: item.year,
      denomination: item.denomination,
      condition: item.condition,
      isNft: item.isNft,
      imagePath: item.imagePath,
      description: item.description,
      createdAt: item.createdAt,
    );
  }
}
