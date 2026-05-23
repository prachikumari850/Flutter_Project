// ============================================================
// data/dummy_data.dart
// Seed/fallback data — constructor updated to match ItemModel v2
// Fields removed: imagePlaceholder, postedDate (now getters)
// Fields added:   userId, postedByEmail, timestamp
// ============================================================

import '../models/item_model.dart';

// Dummy userId used for all seed items (no real Firebase auth here)
const _demoUserId    = 'demo_user_001';
const _demoUserEmail = 'demo@abesit.edu.in';

final List<ItemModel> dummyItems = [
  ItemModel(
    id:             '1',
    title:          'Blue Water Bottle',
    description:    'A blue Nike water bottle with my name written on the bottom. Left near the canteen area.',
    status:         'lost',
    location:       'Main Canteen, Block A',
    category:       'Accessories',
    userId:         _demoUserId,
    postedBy:       'Arjun Sharma',
    postedByEmail:  _demoUserEmail,
    timestamp:      DateTime.now().subtract(const Duration(hours: 2)),
    confidenceScore:87,
  ),
  ItemModel(
    id:             '2',
    title:          'Student ID Card',
    description:    'Found a student ID card near the library entrance. Name: Priya Verma, CS 2nd Year.',
    status:         'found',
    location:       'Library Entrance',
    category:       'Documents',
    userId:         'user_002',
    postedBy:       'Rahul Gupta',
    postedByEmail:  'rahul@abesit.edu.in',
    timestamp:      DateTime.now().subtract(const Duration(hours: 3)),
    confidenceScore:95,
  ),
  ItemModel(
    id:             '3',
    title:          'Black Backpack',
    description:    'Lost my black Wildcraft backpack with laptop inside. Very urgent! Last seen in Lab 3.',
    status:         'lost',
    location:       'Computer Lab 3, Block B',
    category:       'Bags',
    userId:         'user_003',
    postedBy:       'Sneha Patel',
    postedByEmail:  'sneha@abesit.edu.in',
    timestamp:      DateTime.now().subtract(const Duration(days: 1, hours: 7)),
    confidenceScore:72,
  ),
  ItemModel(
    id:             '4',
    title:          'Wireless Earbuds',
    description:    'Found white earbuds (looks like boat) near the basketball court. Case included.',
    status:         'found',
    location:       'Sports Ground',
    category:       'Electronics',
    userId:         'user_004',
    postedBy:       'Vikram Singh',
    postedByEmail:  'vikram@abesit.edu.in',
    timestamp:      DateTime.now().subtract(const Duration(days: 1, hours: 8, minutes: 15)),
    confidenceScore:91,
  ),
  ItemModel(
    id:             '5',
    title:          'Calculator (Casio)',
    description:    'Lost my Casio scientific calculator during the math exam. Has a small scratch on the back.',
    status:         'lost',
    location:       'Exam Hall 2, Block C',
    category:       'Stationery',
    userId:         'user_005',
    postedBy:       'Ananya Mishra',
    postedByEmail:  'ananya@abesit.edu.in',
    timestamp:      DateTime.now().subtract(const Duration(days: 2)),
    confidenceScore:64,
  ),
  ItemModel(
    id:             '6',
    title:          'Laptop Charger',
    description:    'Found a Dell laptop charger in the seminar hall. 65W adapter.',
    status:         'found',
    location:       'Seminar Hall, Block A',
    category:       'Electronics',
    userId:         'user_006',
    postedBy:       'Rohan Kumar',
    postedByEmail:  'rohan@abesit.edu.in',
    timestamp:      DateTime.now().subtract(const Duration(days: 2, hours: 4)),
    confidenceScore:78,
  ),
  ItemModel(
    id:             '7',
    title:          'Red Notebook',
    description:    'Lost a red spiral notebook with DSA notes inside. Very important for upcoming exams!',
    status:         'lost',
    location:       'Reading Room, Library',
    category:       'Stationery',
    userId:         'user_007',
    postedBy:       'Kavya Reddy',
    postedByEmail:  'kavya@abesit.edu.in',
    timestamp:      DateTime.now().subtract(const Duration(days: 3)),
    confidenceScore:83,
  ),
  ItemModel(
    id:             '8',
    title:          'Umbrella (Blue)',
    description:    'Found a folding blue umbrella near the main gate. Good condition.',
    status:         'found',
    location:       'Main Gate',
    category:       'Accessories',
    userId:         'user_008',
    postedBy:       'Amit Joshi',
    postedByEmail:  'amit@abesit.edu.in',
    timestamp:      DateTime.now().subtract(const Duration(days: 3, hours: 5)),
    confidenceScore:69,
  ),
];

// Categories — kept identical, used by HomeScreen & AppConstants
// 'icon' key renamed to match AppConstants.categories ('icon' not 'emoji')
const List<Map<String, dynamic>> categories = [
  {'label': 'Electronics', 'icon': '💻', 'color': 0xFF5C6BC0},
  {'label': 'Documents',   'icon': '📄', 'color': 0xFF26A69A},
  {'label': 'Bags',        'icon': '🎒', 'color': 0xFFEF7C22},
  {'label': 'Accessories', 'icon': '⌚', 'color': 0xFFE53935},
  {'label': 'Stationery',  'icon': '✏️', 'color': 0xFF8D6E63},
  {'label': 'Others',      'icon': '📦', 'color': 0xFF546E7A},
];