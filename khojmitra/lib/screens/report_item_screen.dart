// ============================================================
// screens/report_item_screen.dart
// Form to report lost or found items
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/common_widgets.dart';
import '../models/item_model.dart';
import '../data/dummy_data.dart';

class ReportItemScreen extends StatefulWidget {
  final String? initialStatus;

  const ReportItemScreen({super.key, this.initialStatus});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();

  String _status = 'lost';
  String _category = 'Electronics';
  bool _isSubmitting = false;
  bool _imageMocked = false; // Simulates image pick

  final List<String> _categories = [
    'Electronics', 'Documents', 'Bags', 'Accessories', 'Stationery', 'Others'
  ];

  final List<String> _emojiForCategory = ['💻', '📄', '🎒', '⌚', '✏️', '📦'];

  @override
  void initState() {
    super.initState();
    if (widget.initialStatus != null) {
      _status = widget.initialStatus!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Save item locally
  void _submitItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    // Generate random AI confidence score for demo
    final score = 50 + Random().nextInt(50);
    final index = _categories.indexOf(_category);
    final emoji = index >= 0 ? _emojiForCategory[index] : '📦';

    // Add to local list
    dummyItems.insert(
      0,
      ItemModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}',
        title: _titleController.text,
        description: _descController.text,
        status: _status,
        location: _locationController.text,
        category: _category,
        imagePlaceholder: emoji,
        postedBy: 'Demo User (You)',
        postedDate: 'Just now',
        confidenceScore: score,
      ),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            const Text(
              'Item Reported!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              _status == 'lost'
                  ? 'Your lost item has been posted. We\'ll notify you when a match is found! 🤖'
                  : 'Thanks for reporting a found item! The AI will try to match it with owners.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: 'Back to Home',
              onTap: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.of(context).pop(); // back to home
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report an Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Toggle
              const Text(
                'Item Status',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _StatusToggle(
                    label: '🔴  Lost',
                    isSelected: _status == 'lost',
                    activeColor: AppColors.lost,
                    onTap: () => setState(() => _status = 'lost'),
                  ),
                  const SizedBox(width: 14),
                  _StatusToggle(
                    label: '🟢  Found',
                    isSelected: _status == 'found',
                    activeColor: AppColors.found,
                    onTap: () => setState(() => _status = 'found'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Image Upload (Mocked)
              GestureDetector(
                onTap: () => setState(() => _imageMocked = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: _imageMocked
                        ? AppColors.accent.withOpacity(0.1)
                        : (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkCard
                            : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _imageMocked
                          ? AppColors.accent
                          : AppColors.divider,
                      width: _imageMocked ? 2 : 1,
                      style: _imageMocked
                          ? BorderStyle.solid
                          : BorderStyle.solid,
                    ),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _imageMocked ? '✅' : '📷',
                        style: const TextStyle(fontSize: 36),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _imageMocked
                            ? 'Image Selected (Mock)'
                            : 'Tap to Upload Photo',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _imageMocked
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (!_imageMocked)
                        const Text(
                          'JPG, PNG up to 5MB',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              _FormLabel(label: 'Item Title *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Blue Water Bottle',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter item title' : null,
              ),
              const SizedBox(height: 16),

              // Description
              _FormLabel(label: 'Description *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe the item in detail...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.description_outlined),
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please add a description' : null,
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              _FormLabel(label: 'Category'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                              '${_emojiForCategory[_categories.indexOf(c)]}  $c'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),

              // Location
              _FormLabel(label: 'Last Known Location *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Library, Block A',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter location' : null,
              ),
              const SizedBox(height: 12),

              // AI Note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: const Row(
                  children: [
                    Text('🤖', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'AI will automatically calculate a match confidence score based on your description.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              _isSubmitting
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : GradientButton(
                      label: 'Submit Report',
                      onTap: _submitItem,
                      icon: Icons.send_rounded,
                      colors: _status == 'lost'
                          ? [AppColors.lost, const Color(0xFFE57373)]
                          : [AppColors.found, const Color(0xFF81C784)],
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Form Label ─────────────────────────────────────────────
class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    );
  }
}

// ── Status Toggle ──────────────────────────────────────────
class _StatusToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _StatusToggle({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withOpacity(0.1)
                : (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkCard
                    : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.divider,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [] : AppShadows.cardShadow,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: isSelected ? activeColor : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}