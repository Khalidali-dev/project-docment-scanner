# ML Kit Integration Guide

## 📚 Overview

This app integrates 5 powerful Google ML Kit APIs to process and understand study materials:

1. **Text Recognition** - Convert images to searchable text
2. **Document Scanner** - Clean document capture
3. **Digital Ink Recognition** - Handwriting digitization
4. **Image Labeling** - Auto-categorization
5. **Barcode Scanning** - ISBN tracking

## 🔧 Feature Details

### 1. Text Recognition (OCR)

**Purpose**: Extract text from printed materials and images

**Usage**:
- Scan textbooks
- Extract text from photos
- Process handwritten notes

**Implementation**:
```dart
MLKitService._textRecognizer.processImage(inputImage)
```

**Flow**:
1. User takes photo or selects image
2. ML Kit extracts all text
3. Text stored in database
4. Document becomes searchable

**Features**:
- Automatic language detection (Latin script)
- Line-based organization
- Word-level confidence scores
- Preserves text structure

### 2. Document Scanner

**Purpose**: Scan physical documents as clean PDFs

**Usage**:
- Scan textbook pages
- Capture printed assignments
- Process paper notes

**Implementation**:
```dart
DocumentScanner.scanDocument()
```

**Configuration**:
```dart
DocumentScannerOptions(
  mode: ScannerMode.full,      // Full page scan
  pageLimit: 500,              // Max 500 pages
  isGalleryImport: true,       // Allow gallery
)
```

**Features**:
- Automatic edge detection
- Image enhancement
- Multi-page support
- Gallery import option
- Automatic rotation correction

### 3. Digital Ink Recognition

**Purpose**: Convert handwritten notes to typed text

**Usage**:
- Capture handwritten notes
- Digitize sketches and diagrams
- Convert ink drawings to text

**Implementation**:
```dart
DigitalInkRecognizer.recognize(stroke or ink)
```

**Stroke Data**:
- Individual pen strokes
- Handwriting samples
- Drawing recognition

**Features**:
- Real-time recognition
- Multiple language support
- High accuracy for common scripts
- Returns ranked suggestions

### 4. Image Labeling (Auto-Categorization)

**Purpose**: Automatically identify and categorize content

**Usage**:
- Auto-tag documents by subject
- Category suggestions
- Content classification

**Implementation**:
```dart
ImageLabeler.processImage(inputImage)
```

**Subject Mapping**:
- Mathematics → Math keywords
- Science → Biology, Chemistry, Physics
- History, Geography, Languages
- Computer Science, Literature, Art

**Process**:
1. Image processed by ML Kit
2. Labels extracted (e.g., "diagram", "math")
3. Labels mapped to subjects
4. Subject assigned to document
5. User can edit if needed

**Supported Labels**:
- Academic subjects
- Common educational keywords
- Visual elements (diagram, text, chart)

### 5. Barcode Scanning (ISBN)

**Purpose**: Track books by scanning ISBN barcodes

**Usage**:
- Scan book barcodes
- Extract ISBN automatically
- Track reading progress

**Implementation**:
```dart
BarcodeScanner.processImage(inputImage)
```

**Barcode Types**:
- ISBN-10
- ISBN-13
- EAN-13
- Code-128
- QR codes

**Process**:
1. Photo of barcode captured
2. ML Kit scans for barcodes
3. ISBN extracted from barcode
4. Book details can be added
5. Linked to reading tracker

## 📱 Capture Screen Flow

### Mode 1: Scan Document
```
Select "Scan Document" 
  ↓
Open ML Kit Scanner UI
  ↓
User captures pages
  ↓
ML Kit returns scanned image
  ↓
Extract text with OCR
  ↓
Auto-categorize with Image Labeling
  ↓
Create Thumbnail
  ↓
Save to Database
```

### Mode 2: Take Photo
```
Select "Take Photo"
  ↓
Open Camera
  ↓
User captures image
  ↓
Extract text
  ↓
Auto-categorize
  ↓
Create document entry
  ↓
Save to database
```

### Mode 3: Capture Note
```
Select "Capture Note"
  ↓
Open Camera (for handwritten note)
  ↓
User photographs note
  ↓
Apply Digital Ink Recognition
  ↓
Extract handwritten text
  ↓
Create note entry
  ↓
Save to database
```

### Mode 4: Scan Barcode
```
Select "Scan Barcode"
  ↓
Open Camera (with guide overlay)
  ↓
User positions book barcode
  ↓
Barcode Scanning processes image
  ↓
Extract ISBN
  ↓
Navigate to Book Editor
  ↓
User confirms details
  ↓
Save book entry
```

## 🎯 Subject Categorization

Auto-categorization happens via Image Labeling:

### Label to Subject Mapping
```
Math Keywords → Mathematics
  (equation, number, formula, graph)

Biology/Science → Biology, Science
  (cell, organism, plant, animal)

Chemistry → Chemistry
  (molecule, element, compound)

Physics → Physics
  (motion, energy, force, light)

History → History
  (date, timeline, historical)

Geography → Geography
  (map, location, region, country)

Languages → Languages
  (text, paragraph, document)

Computer Science → Computer Science
  (code, algorithm, program)

Literature → Literature
  (text, book, chapter)

Art → Art
  (drawing, painting, image)

Diagram/Text → General
  (generic educational content)
```

## 🔄 Data Flow

### Complete Processing Pipeline

```
User Input
  ↓
Permission Check
  ↓
Image Capture/Selection
  ↓
ML Kit Processing
  ├─ Text Recognition (OCR)
  ├─ Document Scanning
  ├─ Digital Ink Recognition
  ├─ Image Labeling
  └─ Barcode Scanning
  ↓
Text Extraction & Processing
  ├─ Clean text
  ├─ Extract subjects/categories
  └─ Create thumbnail
  ↓
Database Operations
  ├─ Create entity
  ├─ Store file
  └─ Index for search
  ↓
UI Update
  ├─ Show success
  └─ Update library view
```

## 🛡️ Error Handling

### ML Kit Errors
- Permission denied → Request permission
- Model not downloaded → Download automatically
- Processing failed → Show error, allow retry
- Low quality image → Suggest better angle

### Recovery Strategies
```dart
try {
  final result = await mlKitService.recognizeTextFromFile(path);
} catch (e) {
  if (e.toString().contains('permission')) {
    // Request permission
  } else if (e.toString().contains('model')) {
    // Download model
  } else {
    // Show generic error with retry
  }
}
```

## 📊 Performance Metrics

### Processing Times (Approximate)
- Text Recognition: 500-1500ms
- Document Scanner: 1-3 seconds
- Digital Ink Recognition: 200-800ms
- Image Labeling: 300-1000ms
- Barcode Scanning: 300-1500ms

### Optimization Tips
1. Resize large images before processing
2. Use JPEG format (smaller files)
3. Ensure good lighting for accuracy
4. Keep camera steady
5. Position subject properly

## 🔍 Best Practices

### For Text Recognition
- Use high contrast documents
- Ensure good lighting
- Straight angle (perpendicular)
- Document fills frame
- Clear, readable fonts

### For Document Scanning
- Well-lit environment
- Flat surface
- Clear document edges
- Straight camera angle
- No shadows

### For Handwriting Recognition
- Legible handwriting
- Clear ink/pencil
- Proper contrast
- Straight image
- Single page at a time

### For Image Labeling
- Clear subject matter
- Good image quality
- Proper lighting
- Uncluttered background
- Relevant content

### For Barcode Scanning
- Barcode clearly visible
- Proper lighting
- No glare
- Correct angle
- Full barcode visible

## 🚀 Advanced Features

### Batch Processing
```dart
Future<List<Document>> processBatch(List<String> imagePaths) async {
  List<Document> documents = [];
  for (var path in imagePaths) {
    final doc = await processSingleImage(path);
    documents.add(doc);
  }
  return documents;
}
```

### Real-time Processing
```dart
// While camera preview is active
void onFrameAvailable(CameraImage image) {
  // Process each frame for live feedback
  mlKitService.recognizeTextFromFile(imagePath);
}
```

### Multi-language Support
```dart
final textRecognizer = TextRecognizer(
  script: TextRecognitionScript.latin,
  // Also supports: chinese, devanagari, japanese, korean
);
```

## 📈 Model Management

### ML Kit Models
- Auto-downloaded on first use
- Cached locally
- Updated automatically
- Requires ~50-200MB space

### Download Management
- Models download in background
- User notified when ready
- Can manually trigger updates
- Check available space before download

## 🔐 Privacy & Data

### On-Device Processing
- All ML Kit processing happens locally
- No data sent to Google servers
- No cloud dependency
- Works offline (after model download)

### User Data
- Extracted text stored locally
- OCR results never uploaded
- Handwriting kept private
- Barcodes processed locally

## 🎓 Use Cases

### Student Study Management
1. Scan textbook pages → Extract text → Create searchable documents
2. Photograph notes → Digitize handwriting → Create searchable notes
3. Scan book barcodes → Track reading progress → Organize by subject

### Homework & Assignments
1. Photograph assignment sheet → Extract text → Store by subject
2. Handwritten solutions → Digitize → Organize with course materials
3. Research materials → Scan → Auto-categorize by topic

### Test Preparation
1. Previous exams → Scan pages → Create study materials
2. Lecture notes → Digitize → Organize by topic
3. Reference materials → Label → Easy search and access

## 📚 Resources

### Google ML Kit Documentation
- https://developers.google.com/ml-kit
- Guides for each API
- Code samples
- Performance tips

### Flutter ML Kit Packages
- https://pub.dev/packages/google_mlkit_*
- Package documentation
- Example implementations
- Issue tracking

---

**ML Kit Integration Complete** ✓
Version 1.0.0 with all 5 features implemented
