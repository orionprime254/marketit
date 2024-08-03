class Item {
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final String description;
  final String userId;

  Item({
    required this.userId,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}
