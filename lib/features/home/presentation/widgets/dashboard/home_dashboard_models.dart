class CollectionGroupData {
  const CollectionGroupData({
    required this.label,
    required this.title,
    required this.actionText,
    required this.cards,
  });

  final String label;
  final String title;
  final String actionText;
  final List<PlaceCardData> cards;
}

class PlaceCardData {
  const PlaceCardData({
    required this.date,
    required this.title,
    required this.location,
    required this.imageUrl,
  });

  final String date;
  final String title;
  final String location;
  final String imageUrl;
}
