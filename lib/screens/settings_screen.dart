import 'package:flutter/material.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();
  final DatabaseService _databaseService = DatabaseService();

  late bool _notificationsEnabled;
  late String _appLanguage;
  late String _themeMode;
  late int _documentCount;
  late int _noteCount;
  late int _bookCount;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _notificationsEnabled = _storageService.getNotificationEnabled();
    _appLanguage = _storageService.getAppLanguage() ?? 'en';
    _themeMode = _storageService.getThemeMode() ?? 'system';
    _documentCount = _databaseService.getDocumentCount();
    _noteCount = _databaseService.getNoteCount();
    _bookCount = _databaseService.getBookCount();

    setState(() {});
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This action cannot be undone. All documents, notes, and books will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _databaseService.clearAllData();
      if (mounted) {
        SnackBarHelper.showSuccess(context, 'All data cleared');
        _loadSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Storage Stats
            _buildSectionTitle('Storage'),
            const SizedBox(height: AppDimensions.paddingM),
            _buildStorageCard(),
            const SizedBox(height: AppDimensions.paddingXL),

            // App Settings
            _buildSectionTitle('App Settings'),
            const SizedBox(height: AppDimensions.paddingM),
            _buildSettingsTile(
              'Notifications',
              'Enable notifications',
              _notificationsEnabled,
              (value) {
                setState(() => _notificationsEnabled = value);
                _storageService.setNotificationEnabled(value);
              },
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildLanguageDropdown(),
            const SizedBox(height: AppDimensions.paddingM),
            _buildThemeModeDropdown(),
            const SizedBox(height: AppDimensions.paddingXL),

            // Privacy & Security
            _buildSectionTitle('Privacy & Security'),
            const SizedBox(height: AppDimensions.paddingM),
            _buildInfoTile(
              'Data Encryption',
              'All data is encrypted locally',
              Icons.shield,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildInfoTile(
              'Secure Storage',
              'Using Flutter Secure Storage',
              Icons.security,
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // About
            _buildSectionTitle('About'),
            const SizedBox(height: AppDimensions.paddingM),
            _buildInfoTile(AppStrings.appName, 'Version 1.0.0', Icons.info),
            const SizedBox(height: AppDimensions.paddingM),
            _buildInfoTile(
              'ML Kit Features',
              '5 AI-powered recognition engines',
              Icons.auto_awesome,
            ),
            const SizedBox(height: AppDimensions.paddingXL),

            // Danger Zone
            _buildSectionTitle('Danger Zone'),
            const SizedBox(height: AppDimensions.paddingM),
            CustomButton(
              label: 'Clear All Data',
              onPressed: _clearAllData,
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AppFonts.fontSize18,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildStorageCard() {
    return CustomCard(
      child: Column(
        children: [
          _buildStorageStat('Documents', _documentCount.toString()),
          const Divider(),
          _buildStorageStat('Notes', _noteCount.toString()),
          const Divider(),
          _buildStorageStat('Books', _bookCount.toString()),
        ],
      ),
    );
  }

  Widget _buildStorageStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFonts.fontSize14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppFonts.fontSize16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return CustomCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppFonts.fontSize16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: AppFonts.fontSize12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Language',
            style: TextStyle(
              fontSize: AppFonts.fontSize16,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          DropdownButton<String>(
            value: _appLanguage,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'es', child: Text('Spanish')),
              DropdownMenuItem(value: 'fr', child: Text('French')),
              DropdownMenuItem(value: 'de', child: Text('German')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _appLanguage = value);
                _storageService.setAppLanguage(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeDropdown() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theme',
            style: TextStyle(
              fontSize: AppFonts.fontSize16,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          DropdownButton<String>(
            value: _themeMode,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'system', child: Text('System')),
              DropdownMenuItem(value: 'light', child: Text('Light')),
              DropdownMenuItem(value: 'dark', child: Text('Dark')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _themeMode = value);
                _storageService.setThemeMode(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return CustomCard(
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: AppDimensions.iconL),
          const SizedBox(width: AppDimensions.paddingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppFonts.fontSize16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: AppFonts.fontSize12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
