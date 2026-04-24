import 'package:objectbox/objectbox.dart';

@Entity()
class Book {
  @Id(assignable: true)
  int id = 0;

  @Index()
  String bookId; // UUID

  String title;
  String author;
  String isbn;

  @Index()
  String subject;

  String? description;
  String? publisher;
  String? publicationDate;

  String? coverImagePath;
  String? barcodePath;

  List<String> tags;

  @Index()
  DateTime addedAt;

  DateTime? lastAccessedAt;

  int accessCount = 0;

  // Reading progress
  int totalPages = 0;
  int currentPage = 0;

  // Status: 'unread', 'reading', 'completed'
  String readingStatus = 'unread';

  bool isFavorite = false;
  bool isArchived = false;

  Book({
    required this.bookId,
    required this.title,
    required this.author,
    required this.isbn,
    required this.subject,
    this.description,
    this.publisher,
    this.publicationDate,
    this.coverImagePath,
    this.barcodePath,
    this.tags = const [],
    DateTime? addedAt,
    this.lastAccessedAt,
    this.accessCount = 0,
    this.totalPages = 0,
    this.currentPage = 0,
    this.readingStatus = 'unread',
    this.isFavorite = false,
    this.isArchived = false,
  }) : addedAt = addedAt ?? DateTime.now();

  Book copyWith({
    int? id,
    String? bookId,
    String? title,
    String? author,
    String? isbn,
    String? subject,
    String? description,
    String? publisher,
    String? publicationDate,
    String? coverImagePath,
    String? barcodePath,
    List<String>? tags,
    DateTime? addedAt,
    DateTime? lastAccessedAt,
    int? accessCount,
    int? totalPages,
    int? currentPage,
    String? readingStatus,
    bool? isFavorite,
    bool? isArchived,
  }) {
    return Book(
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      publisher: publisher ?? this.publisher,
      publicationDate: publicationDate ?? this.publicationDate,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      barcodePath: barcodePath ?? this.barcodePath,
      tags: tags ?? this.tags,
      addedAt: addedAt ?? this.addedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      accessCount: accessCount ?? this.accessCount,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      readingStatus: readingStatus ?? this.readingStatus,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
    )..id = id ?? this.id;
  }
}
