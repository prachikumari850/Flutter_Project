// ============================================================
// screens/report_item_screen.dart
// Upgraded: Firebase Storage image upload, Firestore save,
// AI matching triggered after save
// ============================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../utils/theme.dart';
import '../utils/app_constants.dart';
import '../widgets/common_widgets.dart';
import '../models/item_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/ai_matching_service.dart';
import 'package:flutter/foundation.dart';

class ReportItemScreen extends StatefulWidget {
  final String? initialStatus;
  const ReportItemScreen({super.key, this.initialStatus});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _locCtrl   = TextEditingController();

  String  _status      = 'lost';
  String  _category    = 'Electronics';
  File?   _imageFile;
  bool    _isSubmitting= false;
  double  _uploadProgress = 0;
  String  _submitStep  = '';

  final _auth    = AuthService();
  final _fs      = FirestoreService();
  final _storage = StorageService();
  final _ai      = AiMatchingService();
  final _uuid    = const Uuid();
  final _picker  = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialStatus != null) _status = widget.initialStatus!;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  // ── Pick image from gallery or camera ─────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source, imageQuality: 75, maxWidth: 1200);
      if (picked != null) {
        setState(() => _imageFile = File(picked.path));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access camera/gallery.')));
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 16),
          Material(
  color: Colors.transparent,
  child: ListTile(
    leading: const Icon(
      Icons.camera_alt_outlined,
      color: AppColors.primary,
    ),
    title: const Text('Take Photo'),
    onTap: () {
      Navigator.pop(context);
      _pickImage(ImageSource.camera);
    },
  ),
),
          Material(
  color: Colors.transparent,
  child: ListTile(
    leading: const Icon(
      Icons.photo_library_outlined,
      color: AppColors.primary,
    ),
    title: const Text('Choose from Gallery'),
    onTap: () {
      Navigator.pop(context);
      _pickImage(ImageSource.gallery);
    },
  ),
),
          if (_imageFile != null)
            Material(
  color: Colors.transparent,
  child: ListTile(
    leading: const Icon(
      Icons.delete_outline,
      color: AppColors.lost,
    ),
    title: const Text(
      'Remove Photo',
      style: TextStyle(color: AppColors.lost),
    ),
    onTap: () {
      Navigator.pop(context);
      setState(() => _imageFile = null);
    },
  ),
),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  // ── Submit: upload image → save to Firestore → run AI ─
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isSubmitting = true; _submitStep = 'Preparing...'; });

    try {
      final itemId    = _uuid.v4();
      String? imageUrl;

      // 1. Upload image if selected
      if (_imageFile != null) {
        setState(() => _submitStep = 'Uploading image...');
        imageUrl = await _storage.uploadItemImage(
          imageFile: _imageFile!,
          userId:    _auth.uid,
          itemId:    itemId,
          onProgress: (p) =>
              setState(() => _uploadProgress = p),
        );
      }

      // 2. Build item model
      setState(() => _submitStep = 'Saving item...');
      final item = ItemModel(
        id:            itemId,
        title:         _titleCtrl.text.trim(),
        description:   _descCtrl.text.trim(),
        status:        _status,
        location:      _locCtrl.text.trim(),
        category:      _category,
        imageUrl:      imageUrl,
        userId:        _auth.uid,
        postedBy:      _auth.displayName,
        postedByEmail: _auth.email,
        timestamp:     DateTime.now(),
        confidenceScore: 0,
      );

      // 3. Save to Firestore
      final docId = await _fs.addItem(item);
      if (docId == null) throw Exception('Firestore save failed');

      // 4. Run AI matching in background (don't await — let it run)
      setState(() => _submitStep = 'Running AI matching...');
      _ai.runMatchingForNewItem(item.copyWith(id: docId));

      // 5. Done
      if (mounted) {
        setState(() { _isSubmitting = false; _submitStep = ''; });
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() { _isSubmitting = false; _submitStep = ''; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.lost,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎉', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          const Text('Item Reported!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            _status == 'lost'
                ? 'Your lost item has been posted. You\'ll be notified when a match is found! 🤖'
                : 'Thanks! The AI will match it with lost items in real-time.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: 'Back to Home',
            onTap: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // back
            },
          ),
        ]),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status toggle
                  const Text('Item Status',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 10),
                  Row(children: [
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
                  ]),
                  const SizedBox(height: 24),

                  // Image picker
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: _imageFile != null ? 180 : 130,
                      decoration: BoxDecoration(
                        color: _imageFile != null
                            ? AppColors.accent.withOpacity(0.08)
                            : (Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkCard : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _imageFile != null
                              ? AppColors.accent : AppColors.divider,
                          width: _imageFile != null ? 2 : 1,
                        ),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _imageFile != null
                          ? Stack(children: [
                              // Image.file(_imageFile!,
                              //     fit: BoxFit.cover,
                              //     width: double.infinity,
                              //     height: double.infinity),
                              kIsWeb
                                  ? Image.network(
                                      _imageFile!.path,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : Image(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                              Positioned(
                                top: 8, right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.edit,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('📷',
                                    style: TextStyle(fontSize: 36)),
                                const SizedBox(height: 8),
                                const Text('Tap to Upload Photo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary)),
                                const Text('JPG, PNG up to 5MB',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Upload progress bar
                  if (_isSubmitting && _uploadProgress > 0) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: AppColors.divider,
                        color: AppColors.accent,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uploading: ${(_uploadProgress * 100).toInt()}%',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Title
                  _Label('Item Title *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Blue Water Bottle',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter item title' : null,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _Label('Description *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Describe the item in detail (color, brand, marks)...',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please add a description' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  _Label('Category'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.category_outlined)),
                    items: AppConstants.categories
                        .map((c) => DropdownMenuItem(
                              value: c['label'] as String,
                              child: Text(
                                  '${c['icon']}  ${c['label']}'),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _category = v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Location
                  _Label('Last Known Location *'),
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    optionsBuilder: (val) {
                      if (val.text.isEmpty) return const [];
                      return AppConstants.campusLocations.where((l) =>
                          l.toLowerCase().contains(val.text.toLowerCase()));
                    },
                    onSelected: (s) => _locCtrl.text = s,
                    fieldViewBuilder: (_, ctrl, focus, onSub) =>
                        TextFormField(
                          controller: ctrl,
                          focusNode: focus,
                          onFieldSubmitted: (_) => onSub(),
                          decoration: const InputDecoration(
                            hintText: 'e.g. Library, Block A',
                            prefixIcon:
                                Icon(Icons.location_on_outlined),
                          ),
                          onChanged: (v) => _locCtrl.text = v,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Please enter location' : null,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // AI note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: const Row(children: [
                      Text('🤖', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'AI will auto-match your item in real-time and send you an alert if a match is found!',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.primary),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 28),

                  // Submit
                  _isSubmitting
                      ? Column(children: [
                          const CircularProgressIndicator(
                              color: AppColors.primary),
                          const SizedBox(height: 12),
                          Text(_submitStep,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary)),
                        ])
                      : GradientButton(
                          label: 'Submit Report',
                          onTap: _submit,
                          icon: Icons.send_rounded,
                          colors: _status == 'lost'
                              ? [AppColors.lost, const Color(0xFFE57373)]
                              : [AppColors.found,
                                  const Color(0xFF81C784)],
                        ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Overlay while submitting
          if (_isSubmitting)
            Positioned.fill(child: Container(color: Colors.transparent)),
        ],
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(
          fontWeight: FontWeight.w700, fontSize: 14));
}

class _StatusToggle extends StatelessWidget {
  final String label; final bool isSelected;
  final Color activeColor; final VoidCallback onTap;
  const _StatusToggle({required this.label, required this.isSelected,
      required this.activeColor, required this.onTap});

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
                    ? AppColors.darkCard : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isSelected ? activeColor : AppColors.divider,
                width: isSelected ? 2 : 1),
            boxShadow: isSelected ? [] : AppShadows.cardShadow,
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15,
                  color: isSelected ? activeColor : AppColors.textSecondary)),
        ),
      ),
    );
  }
}