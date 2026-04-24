import '../models/index.dart';
import 'database_service.dart';

class SearchService {
  final DatabaseService _databaseService = DatabaseService();

  static final SearchService _instance = SearchService._internal();

  factory SearchService() {
    return _instance;
  }

  SearchService._internal();

  // Global search across all types
  Future<Map<String, dynamic>> globalSearch(String query) async {
    final documents = _databaseService.searchDocuments(query);
    final notes = _databaseService.searchNotes(query);
    final books = _databaseService.searchBooks(query);

    // Record search history
    await _recordSearchHistory(
      query,
      documents.length + notes.length + books.length,
    );

    return {
      'documents': documents,
      'notes': notes,
      'books': books,
      'total': documents.length + notes.length + books.length,
    };
  }

  // Search with filters
  Future<List<Document>> searchDocuments({
    required String query,
    String? subject,
    String? type,
    bool? isFavorite,
    bool? isArchived,
  }) async {
    var results = _databaseService.searchDocuments(query);

    if (subject != null) {
      results = results.where((doc) => doc.subject == subject).toList();
    }

    if (type != null) {
      results = results.where((doc) => doc.documentType == type).toList();
    }

    if (isFavorite != null) {
      results = results.where((doc) => doc.isFavorite == isFavorite).toList();
    }

    if (isArchived != null) {
      results = results.where((doc) => doc.isArchived == isArchived).toList();
    }

    return results;
  }

  // Search notes with filters
  Future<List<Note>> searchNotes({
    required String query,
    String? subject,
    String? type,
    bool? isFavorite,
    bool? isArchived,
  }) async {
    var results = _databaseService.searchNotes(query);

    if (subject != null) {
      results = results.where((note) => note.subject == subject).toList();
    }

    if (type != null) {
      results = results.where((note) => note.noteType == type).toList();
    }

    if (isFavorite != null) {
      results = results.where((note) => note.isFavorite == isFavorite).toList();
    }

    if (isArchived != null) {
      results = results.where((note) => note.isArchived == isArchived).toList();
    }

    return results;
  }

  // Search books with filters
  Future<List<Book>> searchBooks({
    required String query,
    String? subject,
    String? readingStatus,
    bool? isFavorite,
  }) async {
    var results = _databaseService.searchBooks(query);

    if (subject != null) {
      results = results.where((book) => book.subject == subject).toList();
    }

    if (readingStatus != null) {
      results = results
          .where((book) => book.readingStatus == readingStatus)
          .toList();
    }

    if (isFavorite != null) {
      results = results.where((book) => book.isFavorite == isFavorite).toList();
    }

    return results;
  }

  // Search by tags
  Future<List<dynamic>> searchByTag(String tag) async {
    final documents = _databaseService
        .getAllDocuments()
        .where((doc) => doc.tags.contains(tag))
        .toList();
    final notes = _databaseService
        .getAllNotes()
        .where((note) => note.tags.contains(tag))
        .toList();
    final books = _databaseService
        .getAllBooks()
        .where((book) => book.tags.contains(tag))
        .toList();

    return [...documents, ...notes, ...books];
  }

  // Advanced search
  Future<Map<String, dynamic>> advancedSearch({
    String? query,
    String? subject,
    DateTime? startDate,
    DateTime? endDate,
    String? searchType, // 'all', 'documents', 'notes', 'books'
    bool? isFavorite,
  }) async {
    searchType = searchType ?? 'all';
    query = query ?? '';

    Map<String, dynamic> results = {'documents': [], 'notes': [], 'books': []};

    if (searchType == 'all' || searchType == 'documents') {
      var documents = query.isEmpty
          ? _databaseService.getAllDocuments()
          : _databaseService.searchDocuments(query);

      if (subject != null) {
        documents = documents.where((doc) => doc.subject == subject).toList();
      }

      if (isFavorite != null) {
        documents = documents
            .where((doc) => doc.isFavorite == isFavorite)
            .toList();
      }

      if (startDate != null && endDate != null) {
        documents = documents
            .where(
              (doc) =>
                  doc.createdAt.isAfter(startDate) &&
                  doc.createdAt.isBefore(endDate),
            )
            .toList();
      }

      results['documents'] = documents;
    }

    if (searchType == 'all' || searchType == 'notes') {
      var notes = query.isEmpty
          ? _databaseService.getAllNotes()
          : _databaseService.searchNotes(query);

      if (subject != null) {
        notes = notes.where((note) => note.subject == subject).toList();
      }

      if (isFavorite != null) {
        notes = notes.where((note) => note.isFavorite == isFavorite).toList();
      }

      if (startDate != null && endDate != null) {
        notes = notes
            .where(
              (note) =>
                  note.createdAt.isAfter(startDate) &&
                  note.createdAt.isBefore(endDate),
            )
            .toList();
      }

      results['notes'] = notes;
    }

    if (searchType == 'all' || searchType == 'books') {
      var books = query.isEmpty
          ? _databaseService.getAllBooks()
          : _databaseService.searchBooks(query);

      if (subject != null) {
        books = books.where((book) => book.subject == subject).toList();
      }

      if (isFavorite != null) {
        books = books.where((book) => book.isFavorite == isFavorite).toList();
      }

      results['books'] = books;
    }

    return results;
  }

  // Get search suggestions
  List<String> getSearchSuggestions(String query) {
    final Set<String> suggestions = {};

    // From documents
    for (var doc in _databaseService.getAllDocuments()) {
      if (doc.title.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(doc.title);
      }
      for (var tag in doc.tags) {
        if (tag.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add(tag);
        }
      }
    }

    // From notes
    for (var note in _databaseService.getAllNotes()) {
      if (note.title.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(note.title);
      }
      for (var tag in note.tags) {
        if (tag.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add(tag);
        }
      }
    }

    // From books
    for (var book in _databaseService.getAllBooks()) {
      if (book.title.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(book.title);
      }
    }

    return suggestions.toList()..sort();
  }

  // Record search history
  Future<void> _recordSearchHistory(String query, int resultCount) async {
    final history = SearchHistory(
      query: query,
      resultType: 'all',
      resultCount: resultCount,
    );
    await _databaseService.addSearchHistory(history);
  }

  // Get search history
  List<SearchHistory> getSearchHistory({int limit = 10}) {
    return _databaseService.getSearchHistory(limit: limit);
  }

  // Clear search history
  Future<void> clearSearchHistory() async {
    _databaseService.clearSearchHistory();
  }
}
