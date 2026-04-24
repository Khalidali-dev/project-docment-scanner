import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;
  Map<String, dynamic> _searchResults = {
    'documents': [],
    'notes': [],
    'books': [],
    'total': 0,
  };
  List<SearchHistory> _searchHistory = [];
  List<String> _suggestions = [];
  bool _isSearching = false;
  bool _showHistory = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final history = _searchService.getSearchHistory();
    setState(() => _searchHistory = history);
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _showHistory = true;
        _searchResults = {
          'documents': [],
          'notes': [],
          'books': [],
          'total': 0,
        };
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showHistory = false;
    });

    try {
      final results = await _searchService.globalSearch(query);
      setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Search failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    final suggestions = _searchService.getSearchSuggestions(query);
    setState(() => _suggestions = suggestions.take(5).toList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextField(
          controller: _searchController,
          hint: 'Search documents, notes, books...',
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {
            _updateSuggestions(value);
          },
        ),
        elevation: 0,
        backgroundColor: AppColors.surface,
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _showHistory = true;
                  _searchResults = {
                    'documents': [],
                    'notes': [],
                    'books': [],
                    'total': 0,
                  };
                  _suggestions = [];
                });
              },
            ),
        ],
      ),
      body: _showHistory ? _buildSearchHistory() : _buildSearchResults(),
    );
  }

  Widget _buildSearchHistory() {
    if (_searchController.text.isNotEmpty && _suggestions.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.search, color: AppColors.textTertiary),
            title: Text(_suggestions[index]),
            onTap: () {
              _searchController.text = _suggestions[index];
              _performSearch(_suggestions[index]);
            },
          );
        },
      );
    }

    if (_searchHistory.isEmpty) {
      return const EmptyWidget(
        title: 'No Search History',
        message: 'Your search history will appear here',
        icon: Icons.history,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: AppFonts.fontSize18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _searchService.clearSearchHistory();
                  _loadSearchHistory();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: AppFonts.fontSize14,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final search = _searchHistory[index];
              return ListTile(
                leading: const Icon(
                  Icons.history,
                  color: AppColors.textTertiary,
                ),
                title: Text(search.query),
                subtitle: Text(
                  '${search.resultCount} results',
                  style: const TextStyle(
                    fontSize: AppFonts.fontSize12,
                    color: AppColors.textTertiary,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward,
                  size: AppDimensions.iconM,
                ),
                onTap: () {
                  _searchController.text = search.query;
                  _performSearch(search.query);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Results summary
        Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Text(
            'Found ${_searchResults['total']} results',
            style: const TextStyle(
              fontSize: AppFonts.fontSize14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // TabBar
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Documents (${_searchResults['documents'].length})'),
            Tab(text: 'Notes (${_searchResults['notes'].length})'),
            Tab(text: 'Books (${_searchResults['books'].length})'),
          ],
        ),
        // Results
        Expanded(
          child: _isSearching
              ? const LoadingWidget()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDocumentResults(),
                    _buildNoteResults(),
                    _buildBookResults(),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildDocumentResults() {
    final documents = _searchResults['documents'] as List<Document>;

    if (documents.isEmpty) {
      return const EmptyWidget(
        title: 'No Documents Found',
        message: 'Try a different search term',
        icon: Icons.description,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return DocumentCard(
          document: documents[index],
          showActions: false,
          onTap: () => Navigator.pushNamed(
            context,
            '/document_detail',
            arguments: documents[index],
          ),
        );
      },
    );
  }

  Widget _buildNoteResults() {
    final notes = _searchResults['notes'] as List<Note>;

    if (notes.isEmpty) {
      return const EmptyWidget(
        title: 'No Notes Found',
        message: 'Try a different search term',
        icon: Icons.note,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteCard(
          note: notes[index],
          onTap: () => Navigator.pushNamed(
            context,
            '/note_detail',
            arguments: notes[index],
          ),
        );
      },
    );
  }

  Widget _buildBookResults() {
    final books = _searchResults['books'] as List<Book>;

    if (books.isEmpty) {
      return const EmptyWidget(
        title: 'No Books Found',
        message: 'Try a different search term',
        icon: Icons.book,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimensions.paddingM,
        crossAxisSpacing: AppDimensions.paddingM,
        childAspectRatio: 0.7,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(
          book: books[index],
          onTap: () => Navigator.pushNamed(
            context,
            '/book_detail',
            arguments: books[index],
          ),
        );
      },
    );
  }
}
