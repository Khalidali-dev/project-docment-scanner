import 'package:objectbox/objectbox.dart';

@Entity()
class Document {
  @Id(assignable: true)
  int id = 0;

  @Index()
  String documentId; // UUID

  String title;
  String? description;

  @Index()
  String subject;

  String filePath;
  String fileName;

  List<String> tags;
  List<String>? extractedText;

  @Index()
  DateTime createdAt;

  DateTime? updatedAt;
  DateTime? lastAccessedAt;

  int accessCount = 0;

  String documentType; // 'textbook', 'note', 'pdf', 'image'
  String? thumbnailPath;

  // File size in bytes
  int fileSize = 0;

  // Is favorite
  bool isFavorite = false;

  // Is archived
  bool isArchived = false;

  Document({
    required this.documentId,
    required this.title,
    required this.subject,
    required this.filePath,
    required this.fileName,
    required this.documentType,
    this.description,
    this.tags = const [],
    this.extractedText,
    DateTime? createdAt,
    this.updatedAt,
    this.lastAccessedAt,
    this.accessCount = 0,
    this.thumbnailPath,
    this.fileSize = 0,
    this.isFavorite = false,
    this.isArchived = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // Copy with method
  Document copyWith({
    int? id,
    String? documentId,
    String? title,
    String? description,
    String? subject,
    String? filePath,
    String? fileName,
    List<String>? tags,
    List<String>? extractedText,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastAccessedAt,
    int? accessCount,
    String? documentType,
    String? thumbnailPath,
    int? fileSize,
    bool? isFavorite,
    bool? isArchived,
  }) {
    return Document(
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      documentType: documentType ?? this.documentType,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      accessCount: accessCount ?? this.accessCount,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      fileSize: fileSize ?? this.fileSize,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
    )..id = id ?? this.id;
  }
}
