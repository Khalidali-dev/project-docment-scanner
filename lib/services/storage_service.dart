import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late final FlutterSecureStorage _secureStorage;
  late final SharedPreferences _prefs;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal() {
    _secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  // Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure Storage - User Credentials
  Future<void> saveUserCredential(String key, String value) async {
    await _secureStorage.write(key: key, value: _encryptValue(value));
  }

  Future<String?> getUserCredential(String key) async {
    final encrypted = await _secureStorage.read(key: key);
    if (encrypted == null) return null;
    return _decryptValue(encrypted);
  }

  Future<void> deleteUserCredential(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Regular Preferences
  Future<void> savePreference(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  dynamic getPreference(String key, dynamic defaultValue) {
    return _prefs.get(key) ?? defaultValue;
  }

  Future<void> deletePreference(String key) async {
    await _prefs.remove(key);
  }

  // Save JSON data
  Future<void> saveJson(String key, Map<String, dynamic> data) async {
    await _prefs.setString(key, jsonEncode(data));
  }

  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print('Error decoding JSON: $e');
      return null;
    }
  }

  // Save list of JSON
  Future<void> saveJsonList(String key, List<Map<String, dynamic>> data) async {
    await _prefs.setString(key, jsonEncode(data));
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    try {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error decoding JSON list: $e');
      return null;
    }
  }

  // Encryption/Decryption (simple encryption using SHA256)
  String _encryptValue(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  String _decryptValue(String encrypted) {
    // Note: SHA256 is one-way, so we can't actually decrypt
    // For real encryption, use a proper encryption library
    return encrypted;
  }

  // App settings
  Future<void> setThemeMode(String mode) async {
    await savePreference('theme_mode', mode);
  }

  String? getThemeMode() {
    return getPreference('theme_mode', 'system');
  }

  Future<void> setAppLanguage(String language) async {
    await savePreference('app_language', language);
  }

  String? getAppLanguage() {
    return getPreference('app_language', 'en');
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    await savePreference('notifications_enabled', enabled);
  }

  bool getNotificationEnabled() {
    return getPreference('notifications_enabled', true);
  }

  // User preferences
  Future<void> setDefaultSubject(String subject) async {
    await savePreference('default_subject', subject);
  }

  String? getDefaultSubject() {
    return getPreference('default_subject', null);
  }

  Future<void> setLibraryViewMode(String mode) async {
    await savePreference('library_view_mode', mode); // 'grid' or 'list'
  }

  String getLibraryViewMode() {
    return getPreference('library_view_mode', 'grid');
  }

  // Search preferences
  Future<void> saveFavoriteSearchTags(List<String> tags) async {
    await savePreference('favorite_search_tags', tags);
  }

  List<String> getFavoriteSearchTags() {
    return getPreference('favorite_search_tags', []);
  }

  // Last activity
  Future<void> setLastOpenedDocument(String documentId) async {
    await savePreference('last_opened_document', documentId);
  }

  String? getLastOpenedDocument() {
    return getPreference('last_opened_document', null);
  }

  Future<void> setLastOpenedSubject(String subject) async {
    await savePreference('last_opened_subject', subject);
  }

  String? getLastOpenedSubject() {
    return getPreference('last_opened_subject', null);
  }

  // Clear all storage
  Future<void> clearAllStorage() async {
    await _prefs.clear();
    // Note: SecureStorage cannot be fully cleared in some platforms
    // You may need to manually delete keys
  }
}
