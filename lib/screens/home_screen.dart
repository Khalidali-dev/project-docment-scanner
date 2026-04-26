import 'package:flutter/material.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late List<Document> _recentDocuments;
  late List<Note> _recentNotes;
  int _documentCount = 0;
  int _noteCount = 0;
  int _bookCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _recentDocuments = _databaseService.getRecentDocuments(limit: 5);
      _recentNotes = _databaseService
          .getAllNotes()
          .where((note) => !note.isArchived)
          .toList()
          .take(5)
          .toList();
      _documentCount = _databaseService.getDocumentCount();
      _noteCount = _databaseService.getNoteCount();
      _bookCount = _databaseService.getBookCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: AppFonts.fontSize32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),

              // Statistics Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatCard(
                      'Documents',
                      _documentCount.toString(),
                      Icons.description,
                      AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.paddingM),
                    _buildStatCard(
                      'Notes',
                      _noteCount.toString(),
                      Icons.note,
                      AppColors.secondary,
                    ),
                    const SizedBox(width: AppDimensions.paddingM),
                    _buildStatCard(
                      'Books',
                      _bookCount.toString(),
                      Icons.book,
                      AppColors.accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: AppFonts.fontSize20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppDimensions.paddingM,
                crossAxisSpacing: AppDimensions.paddingM,
                children: [
                  _buildActionButton(
                    'Scan Document',
                    Icons.document_scanner,
                    AppColors.primary,
                    () => Navigator.pushNamed(context, '/capture_document'),
                  ),
                  _buildActionButton(
                    'Take Photo',
                    Icons.camera_alt,
                    AppColors.secondary,
                    () => Navigator.pushNamed(context, '/capture_photo'),
                  ),
                  _buildActionButton(
                    'Add Note',
                    Icons.edit_note,
                    AppColors.accent,
                    () => Navigator.pushNamed(context, '/note_editor'),
                  ),
                  _buildActionButton(
                    'Scan Barcode',
                    Icons.qr_code_2,
                    AppColors.warning,
                    () => Navigator.pushNamed(context, '/barcode'),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // Recent Documents
              if (_recentDocuments.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Documents',
                      style: TextStyle(
                        fontSize: AppFonts.fontSize20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/library'),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: AppFonts.fontSize14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentDocuments.length,
                  itemBuilder: (context, index) {
                    return DocumentCard(
                      document: _recentDocuments[index],
                      showActions: false,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/document_detail',
                        arguments: _recentDocuments[index],
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: AppDimensions.paddingXL),

              // Recent Notes
              if (_recentNotes.isNotEmpty) ...[
                const Text(
                  'Recent Notes',
                  style: TextStyle(
                    fontSize: AppFonts.fontSize20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentNotes.length,
                  itemBuilder: (context, index) {
                    return NoteCard(
                      note: _recentNotes[index],
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/note_detail',
                        arguments: _recentNotes[index],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppDimensions.iconL),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFonts.fontSize24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFonts.fontSize12,
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppDimensions.iconXL),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFonts.fontSize14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
