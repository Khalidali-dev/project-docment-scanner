import 'package:flutter/material.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  late List<Subject> _subjects;
  late List<Document> _documents;
  late List<Note> _notes;
  late List<Book> _books;

  final int _selectedTabIndex = 0;
  String? _selectedSubject;
  String _viewMode = 'grid'; // 'grid' or 'list'
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _subjects = _databaseService.getAllSubjects();
    _documents = _databaseService
        .getAllDocuments()
        .where((doc) => !doc.isArchived)
        .toList();
    _notes = _databaseService
        .getAllNotes()
        .where((note) => !note.isArchived)
        .toList();
    _books = _databaseService
        .getAllBooks()
        .where((book) => !book.isArchived)
        .toList();

    _viewMode = _storageService.getLibraryViewMode();

    setState(() => _isLoading = false);
  }

  List<Document> _getFilteredDocuments() {
    if (_selectedSubject == null) return _documents;
    return _documents.where((doc) => doc.subject == _selectedSubject).toList();
  }

  List<Note> _getFilteredNotes() {
    if (_selectedSubject == null) return _notes;
    return _notes.where((note) => note.subject == _selectedSubject).toList();
  }

  List<Book> _getFilteredBooks() {
    if (_selectedSubject == null) return _books;
    return _books.where((book) => book.subject == _selectedSubject).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          elevation: 0,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.text,
          actions: [
            IconButton(
              icon: Icon(
                _viewMode == 'grid' ? Icons.list : Icons.grid_view,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() {
                  _viewMode = _viewMode == 'grid' ? 'list' : 'grid';
                });
                _storageService.setLibraryViewMode(_viewMode);
              },
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Documents (${_documents.length})'),
              Tab(text: 'Notes (${_notes.length})'),
              Tab(text: 'Books (${_books.length})'),
            ],
          ),
        ),
        body: _isLoading
            ? const LoadingWidget()
            : Column(
                children: [
                  // Subject Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    child: Row(
                      children: [
                        _buildSubjectChip(null, 'All'),
                        ...List.generate(
                          _subjects.length,
                          (index) => _buildSubjectChip(
                            _subjects[index].name,
                            _subjects[index].name,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildDocumentsView(),
                        _buildNotesView(),
                        _buildBooksView(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSubjectChip(String? subject, String label) {
    final isSelected = _selectedSubject == subject;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedSubject = subject);
      },
      child: Container(
        margin: const EdgeInsets.only(right: AppDimensions.paddingM),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.fontSize14,
            color: isSelected ? Colors.white : AppColors.text,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsView() {
    final docs = _getFilteredDocuments();

    if (docs.isEmpty) {
      return EmptyWidget(
        title: 'No Documents',
        message: 'Start by scanning a document or textbook',
        icon: Icons.description,
      );
    }

    if (_viewMode == 'grid') {
      return GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppDimensions.paddingM,
          crossAxisSpacing: AppDimensions.paddingM,
          childAspectRatio: 0.7,
        ),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          return DocumentCard(
            document: docs[index],
            onTap: () => _openDocument(docs[index]),
            onToggleFavorite: () => _toggleDocumentFavorite(docs[index]),
            onDelete: () => _deleteDocument(docs[index]),
          );
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          return DocumentCard(
            document: docs[index],
            onTap: () => _openDocument(docs[index]),
            onToggleFavorite: () => _toggleDocumentFavorite(docs[index]),
            onDelete: () => _deleteDocument(docs[index]),
          );
        },
      );
    }
  }

  Widget _buildNotesView() {
    final notes = _getFilteredNotes();

    if (notes.isEmpty) {
      return EmptyWidget(
        title: 'No Notes',
        message: 'Create a new note to get started',
        icon: Icons.note,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteCard(
          note: notes[index],
          onTap: () => _openNote(notes[index]),
          onToggleFavorite: () => _toggleNoteFavorite(notes[index]),
          onDelete: () => _deleteNote(notes[index]),
        );
      },
    );
  }

  Widget _buildBooksView() {
    final books = _getFilteredBooks();

    if (books.isEmpty) {
      return EmptyWidget(
        title: 'No Books',
        message: 'Scan a barcode to add a book',
        icon: Icons.book,
      );
    }

    if (_viewMode == 'grid') {
      return GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppDimensions.paddingM,
          crossAxisSpacing: AppDimensions.paddingM,
          childAspectRatio: 0.52,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(
            book: books[index],
            onTap: () => _openBook(books[index]),
            onToggleFavorite: () => _toggleBookFavorite(books[index]),
            onDelete: () => _deleteBook(books[index]),
          );
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(
            book: books[index],
            onTap: () => _openBook(books[index]),
            onToggleFavorite: () => _toggleBookFavorite(books[index]),
            onDelete: () => _deleteBook(books[index]),
          );
        },
      );
    }
  }

  Future<void> _openDocument(Document document) async {
    final updated = document.copyWith(
      accessCount: document.accessCount + 1,
      lastAccessedAt: DateTime.now(),
    );
    await _databaseService.updateDocument(updated);

    if (mounted) {
      Navigator.pushNamed(context, '/document_detail', arguments: updated);
    }
  }

  Future<void> _openNote(Note note) async {
    final updated = note.copyWith(
      accessCount: note.accessCount + 1,
      lastAccessedAt: DateTime.now(),
    );
    await _databaseService.updateNote(updated);

    if (mounted) {
      Navigator.pushNamed(context, '/note_detail', arguments: updated);
    }
  }

  Future<void> _openBook(Book book) async {
    final updated = book.copyWith(
      accessCount: book.accessCount + 1,
      lastAccessedAt: DateTime.now(),
    );
    await _databaseService.updateBook(updated);

    if (mounted) {
      Navigator.pushNamed(context, '/book_detail', arguments: updated);
    }
  }

  Future<void> _toggleDocumentFavorite(Document document) async {
    final updated = document.copyWith(isFavorite: !document.isFavorite);
    await _databaseService.updateDocument(updated);
    _loadData();
  }

  Future<void> _toggleNoteFavorite(Note note) async {
    final updated = note.copyWith(isFavorite: !note.isFavorite);
    await _databaseService.updateNote(updated);
    _loadData();
  }

  Future<void> _toggleBookFavorite(Book book) async {
    final updated = book.copyWith(isFavorite: !book.isFavorite);
    await _databaseService.updateBook(updated);
    _loadData();
  }

  Future<void> _deleteDocument(Document document) async {
    await _databaseService.deleteDocument(document.id);
    _loadData();
    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Document deleted');
    }
  }

  Future<void> _deleteNote(Note note) async {
    await _databaseService.deleteNote(note.id);
    _loadData();
    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Note deleted');
    }
  }

  Future<void> _deleteBook(Book book) async {
    await _databaseService.deleteBook(book.id);
    _loadData();
    if (mounted) {
      SnackBarHelper.showSuccess(context, 'Book deleted');
    }
  }
}
