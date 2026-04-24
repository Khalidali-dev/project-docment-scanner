import '../models/index.dart';
import '../objectbox.g.dart';

class DatabaseService {
  late final Store _store;
  late final Box<Document> _documentBox;
  late final Box<Note> _noteBox;
  late final Box<Book> _bookBox;
  late final Box<Subject> _subjectBox;
  late final Box<SearchHistory> _searchHistoryBox;

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  // Initialize database
  Future<void> initialize() async {
    if (!_isInitialized) {
      _store = await openStore();
      _documentBox = _store.box<Document>();
      _noteBox = _store.box<Note>();
      _bookBox = _store.box<Book>();
      _subjectBox = _store.box<Subject>();
      _searchHistoryBox = _store.box<SearchHistory>();
    }
  }

  bool get _isInitialized {
    try {
      _store;
      return true;
    } catch (_) {
      return false;
    }
  }

  // Document operations
  Future<int> addDocument(Document document) async {
    return _documentBox.put(document);
  }

  Future<void> updateDocument(Document document) async {
    _documentBox.put(document);
  }

  Future<void> deleteDocument(int id) async {
    _documentBox.remove(id);
  }

  Future<Document?> getDocument(int id) async {
    return _documentBox.get(id);
  }

  List<Document> getAllDocuments() {
    return _documentBox.getAll();
  }

  List<Document> getDocumentsBySubject(String subject) {
    return _documentBox
        .query(Document_.subject.equals(subject))
        .order(Document_.createdAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Document> searchDocuments(String query) {
    return _documentBox
        .query(
          Document_.title
              .contains(query, caseSensitive: false)
              .or(Document_.description.contains(query, caseSensitive: false)),
        )
        .order(Document_.lastAccessedAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Document> getFavoriteDocuments() {
    return _documentBox
        .query(Document_.isFavorite.equals(true))
        .order(Document_.createdAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Document> getRecentDocuments({int limit = 10}) {
    return _documentBox
        .query(Document_.isArchived.equals(false))
        .order(Document_.lastAccessedAt, flags: Order.descending)
        .build()
        .find()
        .take(limit)
        .toList();
  }

  // Note operations
  Future<int> addNote(Note note) async {
    return _noteBox.put(note);
  }

  Future<void> updateNote(Note note) async {
    _noteBox.put(note);
  }

  Future<void> deleteNote(int id) async {
    _noteBox.remove(id);
  }

  Future<Note?> getNote(int id) async {
    return _noteBox.get(id);
  }

  List<Note> getAllNotes() {
    return _noteBox.getAll();
  }

  List<Note> getNotesBySubject(String subject) {
    return _noteBox
        .query(Note_.subject.equals(subject))
        .order(Note_.createdAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Note> searchNotes(String query) {
    return _noteBox
        .query(
          Note_.title
              .contains(query, caseSensitive: false)
              .or(Note_.content.contains(query, caseSensitive: false)),
        )
        .order(Note_.lastAccessedAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Note> getFavoriteNotes() {
    return _noteBox
        .query(Note_.isFavorite.equals(true))
        .order(Note_.createdAt, flags: Order.descending)
        .build()
        .find();
  }

  // Book operations
  Future<int> addBook(Book book) async {
    return _bookBox.put(book);
  }

  Future<void> updateBook(Book book) async {
    _bookBox.put(book);
  }

  Future<void> deleteBook(int id) async {
    _bookBox.remove(id);
  }

  Future<Book?> getBook(int id) async {
    return _bookBox.get(id);
  }

  Book? getBookByISBN(String isbn) {
    final results = _bookBox.query(Book_.isbn.equals(isbn)).build().find();
    return results.isEmpty ? null : results.first;
  }

  List<Book> getAllBooks() {
    return _bookBox.getAll();
  }

  List<Book> getBooksBySubject(String subject) {
    return _bookBox
        .query(Book_.subject.equals(subject))
        .order(Book_.addedAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Book> searchBooks(String query) {
    return _bookBox
        .query(
          Book_.title
              .contains(query, caseSensitive: false)
              .or(Book_.author.contains(query, caseSensitive: false)),
        )
        .order(Book_.addedAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Book> getFavoriteBooks() {
    return _bookBox
        .query(Book_.isFavorite.equals(true))
        .order(Book_.addedAt, flags: Order.descending)
        .build()
        .find();
  }

  List<Book> getBooksReadingStatus(String status) {
    return _bookBox
        .query(Book_.readingStatus.equals(status))
        .order(Book_.lastAccessedAt, flags: Order.descending)
        .build()
        .find();
  }

  // Subject operations
  Future<int> addSubject(Subject subject) async {
    return _subjectBox.put(subject);
  }

  Future<void> updateSubject(Subject subject) async {
    _subjectBox.put(subject);
  }

  Future<void> deleteSubject(int id) async {
    _subjectBox.remove(id);
  }

  Future<Subject?> getSubject(int id) async {
    return _subjectBox.get(id);
  }

  Subject? getSubjectByName(String name) {
    final results = _subjectBox
        .query(Subject_.name.equals(name))
        .build()
        .find();
    return results.isEmpty ? null : results.first;
  }

  List<Subject> getAllSubjects() {
    return _subjectBox.query().order(Subject_.name).build().find();
  }

  // Search history operations
  Future<int> addSearchHistory(SearchHistory history) async {
    return _searchHistoryBox.put(history);
  }

  List<SearchHistory> getSearchHistory({int limit = 10}) {
    return _searchHistoryBox
        .query()
        .order(SearchHistory_.searchedAt, flags: Order.descending)
        .build()
        .find()
        .take(limit)
        .toList();
  }

  void clearSearchHistory() {
    _searchHistoryBox.removeAll();
  }

  // Statistics
  int getDocumentCount() => _documentBox.count();
  int getNoteCount() => _noteBox.count();
  int getBookCount() => _bookBox.count();
  int getSubjectCount() => _subjectBox.count();

  // Clear all data
  Future<void> clearAllData() async {
    _documentBox.removeAll();
    _noteBox.removeAll();
    _bookBox.removeAll();
    _subjectBox.removeAll();
    _searchHistoryBox.removeAll();
  }

  // Close database
  Future<void> close() async {
    _store.close();
  }
}
