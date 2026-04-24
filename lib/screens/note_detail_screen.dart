import 'package:flutter/material.dart';
import 'dart:io';
import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Note _note;
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _titleController = TextEditingController(text: _note.title);
    _contentController = TextEditingController(text: _note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updated = _note.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: DateTime.now(),
    );
    await _databaseService.updateNote(updated);
    _note = updated;
    setState(() => _isEditing = false);
    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Note updated');
    }
  }

  Future<void> _toggleFavorite() async {
    final updated = _note.copyWith(isFavorite: !_note.isFavorite);
    await _databaseService.updateNote(updated);
    setState(() => _note = updated);
  }

  Future<void> _deleteNote() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note?'),
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
      await _databaseService.deleteNote(_note.id);
      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Note deleted');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        actions: [
          IconButton(
            icon: Icon(
              _note.isFavorite ? Icons.favorite : Icons.favorite_border,
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
              PopupMenuItem(onTap: _deleteNote, child: const Text('Delete')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isEditing)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _note.title,
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
                          AppColors.subjectColors[_note.subject] ??
                          AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusS,
                      ),
                    ),
                    child: Text(
                      _note.subject,
                      style: const TextStyle(
                        fontSize: AppFonts.fontSize14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Text(
                    DateTimeUtilities.formatDateTime(_note.createdAt),
                    style: const TextStyle(
                      fontSize: AppFonts.fontSize12,
                      color: AppColors.textTertiary,
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
                    label: 'Content',
                    controller: _contentController,
                    maxLines: 10,
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
            if (!_isEditing) ...[
              const Text(
                'Content',
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
                ),
                child: Text(
                  _note.content,
                  style: const TextStyle(
                    fontSize: AppFonts.fontSize14,
                    color: AppColors.text,
                    height: 1.6,
                  ),
                ),
              ),
              if (_note.tags.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingXL),
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
                  children: _note.tags
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
              ],
            ],
          ],
        ),
      ),
    );
  }
}
