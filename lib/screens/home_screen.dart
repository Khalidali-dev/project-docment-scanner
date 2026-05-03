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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Header
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusXL,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                fontSize: AppFonts.fontSize16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingXS),
                            Text(
                              AppStrings.appName,
                              style: TextStyle(
                                fontSize: AppFonts.fontSize24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingM),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusL,
                          ),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: AppDimensions.iconXL,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),

                // Statistics Cards with Premium Design
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildPremiumStatCard(
                        'Documents',
                        _documentCount.toString(),
                        Icons.description,
                        AppColors.primary,
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      _buildPremiumStatCard(
                        'Notes',
                        _noteCount.toString(),
                        Icons.note,
                        AppColors.secondary,
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      _buildPremiumStatCard(
                        'Books',
                        _bookCount.toString(),
                        Icons.book,
                        AppColors.accent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),

                // Quick Actions with Premium Grid
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusXL,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusM,
                              ),
                            ),
                            child: Icon(
                              Icons.flash_on,
                              color: AppColors.primary,
                              size: AppDimensions.iconM,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingM),
                          Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: AppFonts.fontSize20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingL),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: AppDimensions.paddingM,
                        crossAxisSpacing: AppDimensions.paddingM,
                        children: [
                          _buildPremiumActionButton(
                            'Scan Docs',
                            Icons.document_scanner,
                            AppColors.primary,
                            () => Navigator.pushNamed(
                              context,
                              '/capture_document',
                            ),
                          ),
                          _buildPremiumActionButton(
                            'Take Photo',
                            Icons.camera_alt,
                            AppColors.secondary,
                            () =>
                                Navigator.pushNamed(context, '/capture_photo'),
                          ),
                          _buildPremiumActionButton(
                            'Add Note',
                            Icons.edit_note,
                            AppColors.accent,
                            () => Navigator.pushNamed(context, '/note_editor'),
                          ),
                          _buildPremiumActionButton(
                            'Scan Barcode',
                            Icons.qr_code_2,
                            AppColors.warning,
                            () => Navigator.pushNamed(context, '/barcode'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),

                // Recent Documents with Premium Card
                if (_recentDocuments.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusXL,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(
                                    AppDimensions.paddingXS,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusM,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.description,
                                    color: AppColors.primary,
                                    size: AppDimensions.iconM,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.paddingM),
                                Text(
                                  'Recent Documents',
                                  style: TextStyle(
                                    fontSize: AppFonts.fontSize20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/library'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingM,
                                  vertical: AppDimensions.paddingXS,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusM,
                                  ),
                                ),
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                    fontSize: AppFonts.fontSize14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
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
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: AppDimensions.paddingM,
                              ),
                              child: DocumentCard(
                                document: _recentDocuments[index],
                                showActions: false,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/document_detail',
                                  arguments: _recentDocuments[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppDimensions.paddingXL),

                // Recent Notes with Premium Card
                if (_recentNotes.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusXL,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingXS,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusM,
                                ),
                              ),
                              child: Icon(
                                Icons.note,
                                color: AppColors.secondary,
                                size: AppDimensions.iconM,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingM),
                            Text(
                              'Recent Notes',
                              style: TextStyle(
                                fontSize: AppFonts.fontSize20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.paddingM),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recentNotes.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: AppDimensions.paddingM,
                              ),
                              child: NoteCard(
                                note: _recentNotes[index],
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/note_detail',
                                  arguments: _recentNotes[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXL),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
            ),
            child: Icon(icon, color: color, size: AppDimensions.iconL),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFonts.fontSize28,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFonts.fontSize12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingS),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXL),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusL,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: AppDimensions.iconM),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFonts.fontSize14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
