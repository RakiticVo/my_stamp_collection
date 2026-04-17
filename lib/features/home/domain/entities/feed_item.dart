import 'package:equatable/equatable.dart';

class FeedItem extends Equatable {
  const FeedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.category,
  });

  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String category;

  @override
  List<Object?> get props => [id, title, subtitle, type, category];
}
