// ============================================================
// models/item_model.dart
// Data model for Lost/Found items
// ============================================================

class ItemModel {
  final String id;
  final String title;
  final String description;
  final String status; // 'lost' or 'found'
  final String location;
  final String category;
  final String imagePlaceholder; // emoji or icon name for demo
  final String postedBy;
  final String postedDate;
  final int confidenceScore; // AI confidence (demo)
  bool isReturned;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.location,
    required this.category,
    required this.imagePlaceholder,
    required this.postedBy,
    required this.postedDate,
    required this.confidenceScore,
    this.isReturned = false,
  });
}