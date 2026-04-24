import 'dart:io';

import 'package:flutter/material.dart';

import '../models/index.dart';
import '../utils/index.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onToggleFavorite;
  final bool showActions;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onDelete,
    this.onShare,
    this.onToggleFavorite,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: AppDimensions.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document.thumbnailPath != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.borderRadiusL),
                  topRight: Radius.circular(AppDimensions.borderRadiusL),
                ),
                child: Image.file(
                  File(document.thumbnailPath!),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.borderRadiusL),
                    topRight: Radius.circular(AppDimensions.borderRadiusL),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getDocumentIcon(),
                    size: AppDimensions.iconL,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFonts.fontSize14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingS,
                      vertical: AppDimensions.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors.subjectColors[document.subject] ??
                          AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusS,
                      ),
                    ),
                    child: Text(
                      document.subject,
                      style: const TextStyle(
                        fontSize: AppFonts.fontSize12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    DateTimeUtilities.formatRelativeTime(document.createdAt),
                    style: const TextStyle(
                      fontSize: AppFonts.fontSize12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  if (showActions) ...[
                    const SizedBox(height: AppDimensions.paddingM),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (onToggleFavorite != null)
                          IconButton(
                            icon: Icon(
                              document.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.error,
                              size: AppDimensions.iconM,
                            ),
                            onPressed: onToggleFavorite,
                          ),
                        if (onShare != null)
                          IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: AppColors.primary,
                              size: AppDimensions.iconM,
                            ),
                            onPressed: onShare,
                          ),
                        if (onDelete != null)
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                              size: AppDimensions.iconM,
                            ),
                            onPressed: onDelete,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDocumentIcon() {
    switch (document.documentType) {
      case 'textbook':
        return Icons.book;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      default:
        return Icons.document_scanner;
    }
  }
}

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFavorite;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onDelete,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: AppDimensions.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: AppFonts.fontSize14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  if (onToggleFavorite != null)
                    IconButton(
                      icon: Icon(
                        note.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.error,
                        size: AppDimensions.iconM,
                      ),
                      onPressed: onToggleFavorite,
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: AppDimensions.paddingXS,
                ),
                decoration: BoxDecoration(
                  color:
                      AppColors.subjectColors[note.subject] ??
                      AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusS,
                  ),
                ),
                child: Text(
                  note.subject,
                  style: const TextStyle(
                    fontSize: AppFonts.fontSize12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFonts.fontSize12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateTimeUtilities.formatRelativeTime(note.createdAt),
                    style: const TextStyle(
                      fontSize: AppFonts.fontSize12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  if (onDelete != null)
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.error,
                        size: AppDimensions.iconM,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFavorite;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onDelete,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: AppDimensions.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.coverImagePath != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.borderRadiusL),
                  topRight: Radius.circular(AppDimensions.borderRadiusL),
                ),
                child: Image.file(
                  File(book.coverImagePath!),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      AppColors.subjectColors[book.subject] ??
                      AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.borderRadiusL),
                    topRight: Radius.circular(AppDimensions.borderRadiusL),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.book,
                    size: AppDimensions.iconL,
                    color: Colors.white,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFonts.fontSize14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFonts.fontSize12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (book.totalPages > 0) ...[
                    const SizedBox(height: AppDimensions.paddingS),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusS,
                      ),
                      child: LinearProgressIndicator(
                        value: book.currentPage / book.totalPages,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      '${book.currentPage}/${book.totalPages}',
                      style: const TextStyle(
                        fontSize: AppFonts.fontSize12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.paddingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (onToggleFavorite != null)
                        GestureDetector(
                          onTap: onToggleFavorite,
                          child: Icon(
                            book.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.error,
                            size: AppDimensions.iconM,
                          ),
                        ),
                      if (onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          child: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                            size: AppDimensions.iconM,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
