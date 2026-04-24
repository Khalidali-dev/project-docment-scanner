# Smart Study Assistant

An AI-powered mobile application that helps students digitize and organize study materials using Google ML Kit's machine learning capabilities.

## 🎯 Features

### 📱 ML Kit Powered Features
- **Text Recognition**: Scan textbooks and printed notes using OCR
- **Document Scanner**: Convert papers to searchable PDFs
- **Digital Ink Recognition**: Digitize handwritten notes
- **Image Labeling**: Auto-categorize materials by subject
- **Barcode Scanning**: Track books and resources by ISBN

### 📚 Core Features
- Scan and digitize textbooks and notes
- Convert handwritten notes to searchable text
- Automatically categorize materials by subject
- Build and manage a personal library
- Smart search across all materials
- Secure local storage with encryption
- Instant search with suggestions
- Favorites and archive functionality

### 🏗️ Architecture
Three-Layer Architecture:
- **Presentation Layer**: Flutter widgets and screens
- **Business Logic Layer**: ML Kit integration & data processing
- **Data Layer**: ObjectBox local database with encryption

## 📋 Requirements

- Flutter SDK: ^3.11.5
- Dart: ^3.11.5
- Android 5.0+ (API 21+) / iOS 11.0+
- Minimum 50MB storage space

## 🚀 Installation & Setup

### 1. Get Dependencies
```bash
flutter pub get
```

### 2. Generate ObjectBox Database Code
ObjectBox requires code generation. Run:
```bash
flutter pub run build_runner build
```

This generates:
- ObjectBox entities from model classes
- Database access code
- Query helpers

### 3. Run the App
```bash
# For Android
flutter run

# For iOS
flutter run -d "iPhone Simulator"

# For specific device
flutter run -d <device_id>
```

### 4. Build Release APK
```bash
flutter build apk --release
```

### 5. Build iOS Release
```bash
flutter build ios --release
```

## 📦 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models (ObjectBox entities)
│   ├── document.dart
│   ├── note.dart
│   ├── book.dart
│   ├── subject.dart
│   ├── search_history.dart
│   └── index.dart
├── services/                 # Business logic layer
│   ├── database_service.dart     # ObjectBox database operations
│   ├── mlkit_service.dart        # ML Kit integration
│   ├── storage_service.dart      # Secure local storage
│   ├── search_service.dart       # Search & filtering
│   └── index.dart
├── screens/                  # Presentation layer
│   ├── home_screen.dart           # Dashboard
│   ├── library_screen.dart        # Browse & manage content
│   ├── capture_screen.dart        # ML Kit capture modes
│   ├── search_screen.dart         # Global search
│   ├── settings_screen.dart       # App settings
│   ├── document_detail_screen.dart
│   ├── note_detail_screen.dart
│   ├── book_detail_screen.dart
│   └── index.dart
├── widgets/                  # Reusable UI components
│   ├── common_widgets.dart
│   ├── content_widgets.dart
│   └── index.dart
├── utils/                    # Helper utilities
│   ├── constants.dart        # Colors, dimensions, strings
│   ├── utilities.dart        # Helper functions
│   └── index.dart
└── assets/                   # Images and icons
```

## 🔧 Key Dependencies

### AI/ML
- `google_mlkit_text_recognition`: ^0.15.0 - OCR
- `google_mlkit_document_scanner`: ^0.4.1 - Document scanning
- `google_mlkit_digital_ink_recognition`: ^0.14.1 - Handwriting
- `google_mlkit_image_labeling`: ^0.14.1 - Auto-categorization
- `google_mlkit_barcode_scanning`: ^0.14.1 - ISBN scanning

### Database
- `objectbox`: ^5.3.1 - Local database
- `objectbox_flutter_libs`: ^5.3.1 - Flutter support
- `objectbox_generator`: ^5.3.1 - Code generation

### Storage & Security
- `flutter_secure_storage`: ^9.0.0 - Encrypted storage
- `shared_preferences`: ^2.2.2 - App preferences
- `crypto`: ^3.0.3 - Encryption utilities

### Camera & Media
- `camera`: ^0.10.5+5 - Camera access
- `image_picker`: ^1.0.7 - Image selection
- `image`: ^4.1.7 - Image processing
- `path_provider`: ^2.1.1 - File paths
- `permission_handler`: ^11.4.4 - Permissions

### UI & State
- `provider`: ^6.1.0 - State management
- `google_fonts`: ^6.2.1 - Typography
- `animations`: ^2.0.11 - Transitions

## 🛠️ Configuration

### Android Setup (AndroidManifest.xml)
```xml
<!-- Camera Permission -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- Storage Permissions -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- Query Packages -->
<queries>
    <intent>
        <action android:name="android.intent.action.VIEW" />
    </intent>
</queries>
```

### iOS Setup (Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is needed to scan documents and capture notes</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is needed to import study materials</string>
```

## 📱 Navigation

### Main Navigation Tabs
1. **Home** - Dashboard with statistics and quick actions
2. **Library** - Browse and organize all content
3. **Capture** - Scan documents, take photos, capture notes
4. **Search** - Full-text search across all materials
5. **Settings** - App configuration and preferences

## 🗄️ Database Schema

### Document Entity
```dart
- documentId (UUID)
- title, description
- subject (indexed)
- filePath, fileName
- extractedText
- tags, thumbnailPath
- fileSize, isFavorite, isArchived
- createdAt, updatedAt, lastAccessedAt
```

### Note Entity
```dart
- noteId (UUID)
- title, content
- subject (indexed)
- tags, handwritingImagePath
- noteType (handwritten/typed/mixed)
- createdAt, updatedAt, lastAccessedAt
```

### Book Entity
```dart
- bookId (UUID)
- title, author, isbn
- subject (indexed)
- totalPages, currentPage
- readingStatus (unread/reading/completed)
- addedAt, lastAccessedAt
```

## 🔒 Security Features

- **Local-only Storage**: All data stored on device
- **Encrypted Database**: ObjectBox with encryption
- **Secure Preferences**: Sensitive data in Keychain/Keystore
- **No Cloud Sync**: Privacy-first approach
- **File Encryption**: Encrypted local file storage
- **Permission Handling**: Explicit permission requests

## 🐛 Troubleshooting

### ObjectBox Build Error
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Camera Permission Issues
1. Check `AndroidManifest.xml` permissions
2. Request runtime permissions (Android 6.0+)
3. Check iOS `Info.plist` entries

### ML Kit Failures
- Ensure Google Play Services is installed
- Check ML Kit models download
- Verify image quality and size

### Build Issues
```bash
# Clear all build artifacts
flutter clean

# Upgrade Flutter
flutter upgrade

# Get latest dependencies
flutter pub upgrade
```

## 🚀 Next Steps

### 1. Run Code Generation
```bash
flutter pub run build_runner build
```

### 2. Resolve Any Build Errors
```bash
flutter clean && flutter pub get
```

### 3. Run on Device
```bash
flutter run
```

### 4. Test All Features
- Test document scanning
- Test note digitization
- Test barcode scanning
- Test search functionality
- Test database persistence

## 📄 License

MIT License

---

**Smart Study Assistant v1.0.0** - Transform how students manage study materials!
