import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class BookEditorScreen extends StatefulWidget {
  final String isbn;
  final String? coverImagePath;

  const BookEditorScreen({super.key, required this.isbn, this.coverImagePath});

  @override
  State<BookEditorScreen> createState() => _BookEditorScreenState();
}

class _BookEditorScreenState extends State<BookEditorScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _publicationDateController =
      TextEditingController();
  final TextEditingController _totalPagesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedSubject = 'General';
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _publicationDateController.dispose();
    _totalPagesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    final title = _titleController.text.trim().isEmpty
        ? 'Untitled Book'
        : _titleController.text.trim();
    final author = _authorController.text.trim().isEmpty
        ? 'Unknown Author'
        : _authorController.text.trim();
    final publisher = _publisherController.text.trim().isEmpty
        ? null
        : _publisherController.text.trim();
    final publicationDate = _publicationDateController.text.trim().isEmpty
        ? null
        : _publicationDateController.text.trim();
    final totalPages = int.tryParse(_totalPagesController.text) ?? 0;

    setState(() => _isSaving = true);

    final book = Book(
      bookId: const Uuid().v4(),
      title: title,
      author: author,
      isbn: widget.isbn,
      subject: _selectedSubject,
      description: _descriptionController.text.trim(),
      publisher: publisher,
      publicationDate: publicationDate,
      coverImagePath: widget.coverImagePath,
      barcodePath: widget.coverImagePath,
      tags: [_selectedSubject],
      totalPages: totalPages,
      currentPage: 0,
      readingStatus: 'unread',
    );

    await _databaseService.addBook(book);

    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Book saved successfully');
      Navigator.pushReplacementNamed(context, '/book_detail', arguments: book);
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.coverImagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusL,
                ),
                child: Image.file(
                  File(widget.coverImagePath!),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusL,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.book,
                    size: 72,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            const SizedBox(height: AppDimensions.paddingXL),
            Text(
              'ISBN',
              style: TextStyle(
                fontSize: AppFonts.fontSize14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              widget.isbn,
              style: const TextStyle(
                fontSize: AppFonts.fontSize16,
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            CustomTextField(label: 'Title', controller: _titleController),
            const SizedBox(height: AppDimensions.paddingM),
            CustomTextField(label: 'Author', controller: _authorController),
            const SizedBox(height: AppDimensions.paddingM),
            CustomTextField(
              label: 'Publisher',
              controller: _publisherController,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            CustomTextField(
              label: 'Publication Date',
              controller: _publicationDateController,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            CustomTextField(
              label: 'Total Pages',
              controller: _totalPagesController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            CustomTextField(
              label: 'Description',
              controller: _descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            const Text(
              'Subject',
              style: TextStyle(
                fontSize: AppFonts.fontSize14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Wrap(
              spacing: AppDimensions.paddingS,
              runSpacing: AppDimensions.paddingS,
              children: AppColors.subjectColors.keys.map((subject) {
                final bool selected = subject == _selectedSubject;
                return ChoiceChip(
                  label: Text(subject),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.border,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.text,
                  ),
                  onSelected: (_) => setState(() => _selectedSubject = subject),
                );
              }).toList(),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            CustomButton(
              label: _isSaving ? 'Saving...' : 'Save Book',
              onPressed: () {
                if (!_isSaving) {
                  _saveBook();
                }
              },
              isLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
