import 'dart:io';

import 'package:flutter/material.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class DocumentDetailScreen extends StatefulWidget {
  final Document document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Document _document;
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _document = widget.document;
    _titleController = TextEditingController(text: _document.title);
    _descriptionController = TextEditingController(
      text: _document.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updated = _document.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      updatedAt: DateTime.now(),
    );
    await _databaseService.updateDocument(updated);
    _document = updated;
    setState(() => _isEditing = false);
    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Document updated');
    }
  }

  Future<void> _toggleFavorite() async {
    final updated = _document.copyWith(isFavorite: !_document.isFavorite);
    await _databaseService.updateDocument(updated);
    setState(() => _document = updated);
  }

  Future<void> _deleteDocument() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _databaseService.deleteDocument(_document.id);
      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Document deleted');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
        actions: [
          IconButton(
            icon: Icon(
              _document.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.error,
            ),
            onPressed: _toggleFavorite,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Edit'),
                onTap: () => setState(() => _isEditing = true),
              ),
              PopupMenuItem(
                onTap: _deleteDocument,
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            if (_document.thumbnailPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusL,
                ),
                child: Image.file(
                  File(_document.thumbnailPath!),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusL,
                  ),
                ),
                child: Icon(
                  Icons.image,
                  size: AppDimensions.iconXL,
                  color: AppColors.textTertiary,
                ),
              ),
            const SizedBox(height: AppDimensions.paddingXL),

            // Title
            if (!_isEditing)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _document.title,
                    style: const TextStyle(
                      fontSize: AppFonts.fontSize24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors.subjectColors[_document.subject] ??
                          AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusS,
                      ),
                    ),
                    child: Text(
                      _document.subject,
                      style: const TextStyle(
                        fontSize: AppFonts.fontSize14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  CustomTextField(label: 'Title', controller: _titleController),
                  const SizedBox(height: AppDimensions.paddingM),
                  CustomTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Save',
                          onPressed: _saveChanges,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        child: CustomButton(
                          label: 'Cancel',
                          onPressed: () => setState(() => _isEditing = false),
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: AppDimensions.paddingXL),

            // Information
            _buildInfoSection('File Information', [
              ('Type', _document.documentType),
              ('Created', DateTimeUtilities.formatDate(_document.createdAt)),
              (
                'Last Accessed',
                _document.lastAccessedAt != null
                    ? DateTimeUtilities.formatDate(_document.lastAccessedAt!)
                    : 'Never',
              ),
              ('Access Count', _document.accessCount.toString()),
            ]),

            const SizedBox(height: AppDimensions.paddingXL),

            // Tags
            if (_document.tags.isNotEmpty) ...[
              const Text(
                'Tags',
                style: TextStyle(
                  fontSize: AppFonts.fontSize18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Wrap(
                spacing: AppDimensions.paddingS,
                runSpacing: AppDimensions.paddingS,
                children: _document.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingM,
                          vertical: AppDimensions.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusM,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: AppFonts.fontSize12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
            ],

            // Extracted Text
            if (_document.extractedText != null &&
                _document.extractedText!.isNotEmpty) ...[
              const Text(
                'Extracted Text',
                style: TextStyle(
                  fontSize: AppFonts.fontSize18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusL,
                  ),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  _document.extractedText!.join('\n'),
                  style: const TextStyle(
                    fontSize: AppFonts.fontSize12,
                    color: AppColors.text,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<(String, String)> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppFonts.fontSize18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        ...items.map((item) {
          final (label, value) = item;
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppFonts.fontSize14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppFonts.fontSize14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
