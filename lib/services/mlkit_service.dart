import 'dart:io';

import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

class MLKitService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _inkRecognizer = DigitalInkRecognizer(languageCode: '');
  late final BarcodeScanner _barcodeScanner;
  late final ImageLabeler _imageLabeler;
  late final DocumentScanner _documentScanner;

  static final MLKitService _instance = MLKitService._internal();

  factory MLKitService() {
    return _instance;
  }

  MLKitService._internal() {
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _barcodeScanner = BarcodeScanner();
      _imageLabeler = ImageLabeler(options: ImageLabelerOptions());
      _documentScanner = DocumentScanner(
        options: DocumentScannerOptions(
          mode: ScannerMode.full,
          pageLimit: 500,
          isGalleryImport: true,
        ),
      );
    } catch (e) {
      print('Error initializing ML Kit services: $e');
    }
  }

  // Text Recognition
  Future<String> recognizeTextFromFile(String filePath) async {
    try {
      final inputImage = InputImage.fromFile(File(filePath));
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      String text = '';
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            text += '${element.text} ';
          }
          text += '\n';
        }
      }

      return text;
    } catch (e) {
      print('Error recognizing text: $e');
      return '';
    }
  }

  // Document Scanner
  Future<DocumentScanningResult?> scanDocument() async {
    try {
      final result = await _documentScanner.scanDocument();
      return result;
    } catch (e) {
      print('Error scanning document: $e');
      return null;
    }
  }

  // Digital Ink Recognition
  Future<List<RecognitionCandidate>> recognizeHandwriting(Ink ink) async {
    try {
      final List<RecognitionCandidate> candidates = await _inkRecognizer
          .recognize(ink);
      return candidates;
    } catch (e) {
      print('Error recognizing handwriting: $e');
      return [];
    }
  }

  Future<List<RecognitionCandidate>> recognizeHandwritingFromMultipleStrokes(
    List<Stroke> strokes,
  ) async {
    try {
      final Ink ink = Ink()..strokes = strokes;
      final List<RecognitionCandidate> candidates = await _inkRecognizer
          .recognize(ink);
      return candidates;
    } catch (e) {
      print('Error recognizing handwriting: $e');
      return [];
    }
  }

  // Image Labeling
  Future<List<String>> labelImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final List<ImageLabel> labels = await _imageLabeler.processImage(
        inputImage,
      );

      List<String> labelTexts = [];
      for (ImageLabel label in labels) {
        labelTexts.add(label.label);
      }

      return labelTexts;
    } catch (e) {
      print('Error labeling image: $e');
      return [];
    }
  }

  // Map image labels to subjects
  Future<List<String>> categorizeDocument(String imagePath) async {
    try {
      final labels = await labelImage(imagePath);
      return _mapLabelsToSubjects(labels);
    } catch (e) {
      print('Error categorizing document: $e');
      return [];
    }
  }

  List<String> _mapLabelsToSubjects(List<String> labels) {
    final Map<String, String> labelToSubjectMap = {
      'math': 'Mathematics',
      'number': 'Mathematics',
      'equation': 'Mathematics',
      'biology': 'Biology',
      'science': 'Science',
      'chemistry': 'Chemistry',
      'physics': 'Physics',
      'history': 'History',
      'geography': 'Geography',
      'literature': 'Literature',
      'language': 'Languages',
      'computer': 'Computer Science',
      'code': 'Computer Science',
      'art': 'Art',
      'diagram': 'General',
      'text': 'General',
      'document': 'General',
      'education': 'General',
    };

    Set<String> subjects = {};
    for (String label in labels) {
      final lowerLabel = label.toLowerCase();
      labelToSubjectMap.forEach((key, value) {
        if (lowerLabel.contains(key)) {
          subjects.add(value);
        }
      });
    }

    return subjects.isEmpty ? ['General'] : subjects.toList();
  }

  // Barcode Scanning
  Future<List<Barcode>> scanBarcode(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final List<Barcode> barcodes = await _barcodeScanner.processImage(
        inputImage,
      );

      return barcodes;
    } catch (e) {
      print('Error scanning barcode: $e');
      return [];
    }
  }

  Future<String?> extractISBNFromBarcode(String imagePath) async {
    try {
      final barcodes = await scanBarcode(imagePath);

      for (Barcode barcode in barcodes) {
        if (barcode.type == BarcodeType.isbn) {
          return barcode.displayValue;
        }
      }

      return null;
    } catch (e) {
      print('Error extracting ISBN: $e');
      return null;
    }
  }

  // Image Processing
  Future<String> createThumbnail(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return imagePath;

      final thumbnail = img.copyResize(image, width: 150, height: 200);

      final thumbnailPath = imagePath
          .replaceAll('.jpg', '_thumb.jpg')
          .replaceAll('.png', '_thumb.png');
      final thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(img.encodeJpg(thumbnail));

      return thumbnailPath;
    } catch (e) {
      print('Error creating thumbnail: $e');
      return imagePath;
    }
  }

  // Clean up resources
  Future<void> dispose() async {
    await _textRecognizer.close();
    await _inkRecognizer.close();
    await _barcodeScanner.close();
    await _imageLabeler.close();
  }
}
