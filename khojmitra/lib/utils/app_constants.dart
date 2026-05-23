// // ============================================================
// // utils/app_constants.dart
// // App-wide constants — collection names, categories, config
// // ============================================================
 
// class AppConstants {
//   // Firestore collection names
//   static const String itemsCollection = 'items';
//   static const String usersCollection = 'users';
//   static const String matchesCollection = 'matches';
 
//   // Firebase Storage path prefix
//   static const String itemImagesPath = 'item_images';
 
//   // AI match threshold — scores ≥ this trigger an alert
//   static const int matchThreshold = 75;
 
//   // Item categories (label, emoji, hex color)
//   static const List<Map<String, dynamic>> categories = [
//     {'label': 'Electronics', 'icon': '💻', 'color': 0xFF5C6BC0},
//     {'label': 'Documents',   'icon': '📄', 'color': 0xFF26A69A},
//     {'label': 'Bags',        'icon': '🎒', 'color': 0xFFEF7C22},
//     {'label': 'Accessories', 'icon': '⌚', 'color': 0xFFE53935},
//     {'label': 'Stationery',  'icon': '✏️', 'color': 0xFF8D6E63},
//     {'label': 'Others',      'icon': '📦', 'color': 0xFF546E7A},
//   ];
 
//   // Campus location suggestions
//   static const List<String> campusLocations = [
//     'Main Canteen',
//     'Library Entrance',
//     'Block A',
//     'Block B',
//     'Block C',
//     'Computer Lab 1',
//     'Computer Lab 2',
//     'Computer Lab 3',
//     'Exam Hall',
//     'Seminar Hall',
//     'Sports Ground',
//     'Main Gate',
//     'Parking Area',
//     'Reading Room',
//     'Workshop',
//   ];
// }

// ============================================================
// utils/app_constants.dart
// Firestore collection names, categories, campus locations
// ============================================================

class AppConstants {
  // Firestore collections
  static const String colItems         = 'items';
  static const String colUsers         = 'users';
  static const String colMatches       = 'matches';
  static const String colNotifications = 'notifications';

  // Firebase Storage path
  static const String storageItems = 'item_images';

  // AI matching threshold (%)
  static const int matchThreshold = 75;

  // Categories (matches existing dummy_data structure)
  static const List<Map<String, dynamic>> categories = [
    {'label': 'Electronics', 'icon': '💻', 'color': 0xFF5C6BC0},
    {'label': 'Documents',   'icon': '📄', 'color': 0xFF26A69A},
    {'label': 'Bags',        'icon': '🎒', 'color': 0xFFEF7C22},
    {'label': 'Accessories', 'icon': '⌚', 'color': 0xFFE53935},
    {'label': 'Stationery',  'icon': '✏️', 'color': 0xFF8D6E63},
    {'label': 'Others',      'icon': '📦', 'color': 0xFF546E7A},
  ];

  // Campus location suggestions
  static const List<String> campusLocations = [
    'Main Canteen', 'Main Canteen, Block A',
    'Library', 'Library Entrance', 'Reading Room, Library',
    'Block A', 'Block B', 'Block C',
    'Computer Lab 1', 'Computer Lab 2', 'Computer Lab 3, Block B',
    'Exam Hall', 'Exam Hall 2, Block C',
    'Seminar Hall', 'Seminar Hall, Block A',
    'Sports Ground', 'Main Gate', 'Parking Area', 'Workshop',
  ];
}