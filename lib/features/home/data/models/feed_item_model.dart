import '../../domain/entities/feed_item.dart';

class FeedItemModel extends FeedItem {
  const FeedItemModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.type,
    required super.category,
  });

  factory FeedItemModel.fromJson(Map<String, dynamic> json) {
    return FeedItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type,
      'category': category,
    };
  }
}
