import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFFEC4899);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFF3F4F6);

  static const Color text = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFFD1D5DB);

  static const Color divider = Color(0xFFEEEEEE);

  // Subject colors
  static const Map<String, Color> subjectColors = {
    'Mathematics': Color(0xFF6366F1),
    'Science': Color(0xFF10B981),
    'Biology': Color(0xFF06B6D4),
    'Chemistry': Color(0xFFEC4899),
    'Physics': Color(0xFFF59E0B),
    'History': Color(0xFF8B5CF6),
    'Geography': Color(0xFF14B8A6),
    'Languages': Color(0xFFEF4444),
    'Computer Science': Color(0xFF0EA5E9),
    'Literature': Color(0xFFA78BFA),
    'Art': Color(0xFFF97316),
    'General': Color(0xFF6B7280),
  };
}

class AppDimensions {
  static const double paddingXXS = 4.0;
  static const double paddingXS = 8.0;
  static const double paddingS = 12.0;
  static const double paddingM = 16.0;
  static const double paddingL = 20.0;
  static const double paddingXL = 24.0;
  static const double paddingXXL = 32.0;

  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXL = 16.0;
  static const double borderRadiusXXL = 24.0;

  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
}

class AppFonts {
  static const String fontFamily = 'Outfit';

  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
}

class AppStrings {
  static const String appName = 'Smart Study Assistant';

  // Navigation
  static const String home = 'Home';
  static const String library = 'Library';
  static const String capture = 'Capture';
  static const String search = 'Search';
  static const String settings = 'Settings';

  // Buttons
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String next = 'Next';
  static const String prev = 'Previous';
  static const String done = 'Done';
  static const String submit = 'Submit';

  // Document types
  static const String textbook = 'Textbook';
  static const String note = 'Note';
  static const String pdf = 'PDF';
  static const String image = 'Image';

  // Capture modes
  static const String scanDocument = 'Scan Document';
  static const String scanTextbook = 'Scan Textbook';
  static const String captureNote = 'Capture Note';
  static const String takePhoto = 'Take Photo';
  static const String scanBarcode = 'Scan Barcode';
  static const String digitalInk = 'Digital Ink';

  // Status
  static const String processing = 'Processing...';
  static const String success = 'Success';
  static const String error = 'Error';
  static const String loading = 'Loading...';

  // Messages
  static const String noData = 'No data found';
  static const String tryAgain = 'Try Again';
  static const String selectItem = 'Please select an item';
}

class DocumentTypes {
  static const String textbook = 'textbook';
  static const String note = 'note';
  static const String pdf = 'pdf';
  static const String image = 'image';
}

class NoteTypes {
  static const String handwritten = 'handwritten';
  static const String typed = 'typed';
  static const String mixed = 'mixed';
}

class DefaultSubjects {
  static const List<String> subjects = [
    'Mathematics',
    'Science',
    'Biology',
    'Chemistry',
    'Physics',
    'History',
    'Geography',
    'Languages',
    'Computer Science',
    'Literature',
    'Art',
  ];
}
