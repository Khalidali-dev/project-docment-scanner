import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class FileUtilities {
  static Future<String> getDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> getTemporaryDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory;
  }

  static Future<String> createDocumentFolder() async {
    final baseDir = await getDocumentsDirectory();
    final docDir = Directory('$baseDir/documents');

    if (!await docDir.exists()) {
      await docDir.create(recursive: true);
    }

    return docDir.path;
  }

  static Future<String> createNotesFolder() async {
    final baseDir = await getDocumentsDirectory();
    final notesDir = Directory('$baseDir/notes');

    if (!await notesDir.exists()) {
      await notesDir.create(recursive: true);
    }

    return notesDir.path;
  }

  static Future<String> createBooksFolder() async {
    final baseDir = await getDocumentsDirectory();
    final booksDir = Directory('$baseDir/books');

    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }

    return booksDir.path;
  }

  static Future<String> createThumbnailsFolder() async {
    final baseDir = await getDocumentsDirectory();
    final thumbDir = Directory('$baseDir/thumbnails');

    if (!await thumbDir.exists()) {
      await thumbDir.create(recursive: true);
    }

    return thumbDir.path;
  }

  static Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<int> getFileSize(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes == 0)
        ? 0
        : (bytes / 1024).truncate().toStringAsExponential(0).split('e').last;
    return "${(bytes / (1024 * 1024)).truncate()} $suffixes";
  }

  static String getFileExtension(String fileName) {
    if (!fileName.contains('.')) return '';
    return fileName.split('.').last.toLowerCase();
  }

  static String getFileNameWithoutExtension(String fileName) {
    if (!fileName.contains('.')) return fileName;
    return fileName.substring(0, fileName.lastIndexOf('.'));
  }
}

class DateTimeUtilities {
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm');
    return formatter.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days day${days > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }
}

class ValidationUtilities {
  static bool isValidEmail(String email) {
    // Using triple quotes r'''...''' allows single quotes inside the regex
    final emailRegex = RegExp(
      r'''^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$''',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidISBN(String isbn) {
    // Remove formatting characters
    String cleanIsbn = isbn.replaceAll('-', '').replaceAll(' ', '');

    // Check lengths for ISBN-10 or ISBN-13
    if (cleanIsbn.length != 10 && cleanIsbn.length != 13) return false;

    // Ensure it only contains digits
    return RegExp(r'^[0-9]+$').hasMatch(cleanIsbn);
  }

  static bool isValidBarcode(String barcode) {
    return barcode.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(barcode);
  }

  static bool isValidTitle(String title) {
    return title.isNotEmpty && title.length >= 3;
  }

  static bool isValidSubject(String subject) {
    return subject.isNotEmpty && subject.length >= 2;
  }
}

class StringUtilities {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static List<String> extractTags(String text) {
    final regex = RegExp(r'#\w+');
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  static List<String> extractEmails(String text) {
    final regex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  static String removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }
}

class NumberUtilities {
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  static String formatDecimal(double number, {int decimals = 2}) {
    return number.toStringAsFixed(decimals);
  }

  static String formatPercent(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
}
