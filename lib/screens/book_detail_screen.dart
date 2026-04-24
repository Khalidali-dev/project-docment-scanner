import 'dart:io';

import 'package:flutter/material.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Book _book;
  late TextEditingController _currentPageController;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _currentPageController = TextEditingController(
      text: _book.currentPage.toString(),
    );
  }

  @override
  void dispose() {
    _currentPageController.dispose();
    super.dispose();
  }

  Future<void> _updateReadingProgress() async {
    final currentPage = int.tryParse(_currentPageController.text) ?? 0;
    final updated = _book.copyWith(currentPage: currentPage);
    await _databaseService.updateBook(updated);
    setState(() => _book = updated);
    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Progress updated');
    }
  }

  Future<void> _updateReadingStatus(String status) async {
    final updated = _book.copyWith(readingStatus: status);
    await _databaseService.updateBook(updated);
    setState(() => _book = updated);
  }

  Future<void> _toggleFavorite() async {
    final updated = _book.copyWith(isFavorite: !_book.isFavorite);
    await _databaseService.updateBook(updated);
    setState(() => _book = updated);
  }

  Future<void> _deleteBook() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book?'),
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
      await _databaseService.deleteBook(_book.id);
      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Book deleted');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          IconButton(
            icon: Icon(
              _book.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.error,
            ),
            onPressed: _toggleFavorite,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(onTap: _deleteBook, child: const Text('Delete')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            if (_book.coverImagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusL,
                ),
                child: Image.file(
                  File(_book.coverImagePath!),
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
                  color:
                      AppColors.subjectColors[_book.subject] ??
                      AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusL,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.book,
                    size: AppDimensions.iconXL,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: AppDimensions.paddingXL),

            // Title & Author
            Text(
              _book.title,
              style: const TextStyle(
                fontSize: AppFonts.fontSize24,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              'by ${_book.author}',
              style: const TextStyle(
                fontSize: AppFonts.fontSize16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),

            // Subject Tag
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              decoration: BoxDecoration(
                color:
                    AppColors.subjectColors[_book.subject] ?? AppColors.primary,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusS,
                ),
              ),
              child: Text(
                _book.subject,
                style: const TextStyle(
                  fontSize: AppFonts.fontSize14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // Reading Status
            const Text(
              'Reading Status',
              style: TextStyle(
                fontSize: AppFonts.fontSize18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Row(
              children: [
                Expanded(child: _buildStatusButton('Unread', 'unread')),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(child: _buildStatusButton('Reading', 'reading')),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(child: _buildStatusButton('Completed', 'completed')),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // Reading Progress
            if (_book.totalPages > 0) ...[
              const Text(
                'Reading Progress',
                style: TextStyle(
                  fontSize: AppFonts.fontSize18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusS,
                ),
                child: LinearProgressIndicator(
                  value: _book.currentPage / _book.totalPages,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Current Page',
                      controller: _currentPageController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.paddingL),
                    child: Text(
                      '/ ${_book.totalPages}',
                      style: const TextStyle(
                        fontSize: AppFonts.fontSize16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
              CustomButton(
                label: 'Update Progress',
                onPressed: _updateReadingProgress,
              ),
              const SizedBox(height: AppDimensions.paddingXL),
            ],

            // Book Information
            const Text(
              'Book Information',
              style: TextStyle(
                fontSize: AppFonts.fontSize18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildInfoRow('ISBN', _book.isbn),
            if (_book.publisher != null)
              _buildInfoRow('Publisher', _book.publisher!),
            if (_book.publicationDate != null)
              _buildInfoRow('Published', _book.publicationDate!),
            _buildInfoRow('Added', DateTimeUtilities.formatDate(_book.addedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, String status) {
    final isSelected = _book.readingStatus == status;
    return GestureDetector(
      onTap: () => _updateReadingStatus(status),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFonts.fontSize12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: AppFonts.fontSize14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
