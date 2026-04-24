import 'package:objectbox/objectbox.dart';

@Entity()
class Subject {
  @Id(assignable: true)
  int id = 0;

  @Index()
  String subjectId; // UUID

  String name;
  String? description;
  String? iconPath;
  String color; // Hex color

  @Index()
  DateTime createdAt;

  DateTime? updatedAt;

  // Stats
  int documentCount = 0;
  int noteCount = 0;
  int bookCount = 0;

  Subject({
    required this.subjectId,
    required this.name,
    required this.color,
    this.description,
    this.iconPath,
    DateTime? createdAt,
    this.updatedAt,
    this.documentCount = 0,
    this.noteCount = 0,
    this.bookCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Subject copyWith({
    int? id,
    String? subjectId,
    String? name,
    String? description,
    String? iconPath,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? documentCount,
    int? noteCount,
    int? bookCount,
  }) {
    return Subject(
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      color: color ?? this.color,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documentCount: documentCount ?? this.documentCount,
      noteCount: noteCount ?? this.noteCount,
      bookCount: bookCount ?? this.bookCount,
    )..id = id ?? this.id;
  }
}
