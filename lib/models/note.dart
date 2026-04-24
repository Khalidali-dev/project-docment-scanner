import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  @Id(assignable: true)
  int id = 0;

  @Index()
  String noteId; // UUID

  String title;
  String content; // Extracted text from handwriting or typed

  @Index()
  String subject;

  List<String> tags;

  @Index()
  DateTime createdAt;

  DateTime? updatedAt;
  DateTime? lastAccessedAt;

  int accessCount = 0;

  String noteType; // 'handwritten', 'typed', 'mixed'
  String? handwritingImagePath; // Path to original handwriting image
  String? thumbnailPath;

  // Is favorite
  bool isFavorite = false;

  // Is archived
  bool isArchived = false;

  // Digitized ink data (can store raw ink points)
  String? digitizedInkData;

  Note({
    required this.noteId,
    required this.title,
    required this.content,
    required this.subject,
    required this.noteType,
    this.tags = const [],
    this.handwritingImagePath,
    this.thumbnailPath,
    DateTime? createdAt,
    this.updatedAt,
    this.lastAccessedAt,
    this.accessCount = 0,
    this.isFavorite = false,
    this.isArchived = false,
    this.digitizedInkData,
  }) : createdAt = createdAt ?? DateTime.now();

  Note copyWith({
    int? id,
    String? noteId,
    String? title,
    String? content,
    String? subject,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastAccessedAt,
    int? accessCount,
    String? noteType,
    String? handwritingImagePath,
    String? thumbnailPath,
    bool? isFavorite,
    bool? isArchived,
    String? digitizedInkData,
  }) {
    return Note(
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      content: content ?? this.content,
      subject: subject ?? this.subject,
      noteType: noteType ?? this.noteType,
      tags: tags ?? this.tags,
      handwritingImagePath: handwritingImagePath ?? this.handwritingImagePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      accessCount: accessCount ?? this.accessCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      digitizedInkData: digitizedInkData ?? this.digitizedInkData,
    )..id = id ?? this.id;
  }
}
