import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class CaptureScreen extends StatefulWidget {
  final String? initialMode;

  const CaptureScreen({super.key, this.initialMode});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final MLKitService _mlKitService = MLKitService();
  final ImagePicker _imagePicker = ImagePicker();

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isProcessing = false;
  String? _selectedMode; // 'document', 'photo', 'note', 'barcode'

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.initialMode;
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _selectCamera(0);
      }
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  Future<void> _selectCamera(int index) async {
    _selectedCameraIndex = index;

    _cameraController?.dispose();

    _cameraController = CameraController(
      _cameras![index],
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _mlKitService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedMode == null) {
      return _buildModeSelection();
    }

    switch (_selectedMode) {
      case 'document':
        return _buildDocumentScannerMode();
      case 'photo':
        return _buildPhotoMode();
      case 'note':
        return _buildNoteMode();
      case 'barcode':
        return _buildBarcodeMode();
      default:
        return _buildModeSelection();
    }
  }

  Widget _buildModeSelection() {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Mode')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          children: [
            _buildCaptureOption(
              'Scan Document',
              'Digitize textbooks and printed materials',
              Icons.document_scanner,
              AppColors.primary,
              () => setState(() => _selectedMode = 'document'),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildCaptureOption(
              'Take Photo',
              'Capture study materials with camera',
              Icons.camera_alt,
              AppColors.secondary,
              () => setState(() => _selectedMode = 'photo'),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildCaptureOption(
              'Capture Note',
              'Digitize handwritten notes',
              Icons.edit_note,
              AppColors.accent,
              () => setState(() => _selectedMode = 'note'),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildCaptureOption(
              'Scan Barcode',
              'Track books by scanning ISBN barcode',
              Icons.qr_code_2,
              AppColors.warning,
              () => setState(() => _selectedMode = 'barcode'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentScannerMode() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedMode = null),
        ),
      ),
      body: Center(
        child: CustomButton(
          label: 'Scan with ML Kit',
          onPressed: _isProcessing ? () {} : _scanDocument,
          isLoading: _isProcessing,
        ),
      ),
    );
  }

  Widget _buildPhotoMode() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Take Photo'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selectedMode = null),
          ),
        ),
        body: const LoadingWidget(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedMode = null),
        ),
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: AppDimensions.paddingXL,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _isProcessing ? null : _pickPhotoFromGallery,
                  backgroundColor: AppColors.secondary,
                  child: const Icon(Icons.image),
                ),
                FloatingActionButton(
                  onPressed: _isProcessing ? null : _takePhoto,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.camera),
                ),
                FloatingActionButton(
                  onPressed: _cameras != null && _cameras!.length > 1
                      ? () => _selectCamera(
                          (_selectedCameraIndex + 1) % _cameras!.length,
                        )
                      : null,
                  backgroundColor: AppColors.accent,
                  child: const Icon(Icons.flip_camera_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteMode() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Handwritten Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedMode = null),
        ),
      ),
      body: DrawingCanvas(onTextRecognized: _onHandwritingRecognized),
    );
  }

  Widget _buildBarcodeMode() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Barcode'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selectedMode = null),
          ),
        ),
        body: const LoadingWidget(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Book Barcode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedMode = null),
        ),
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusL,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppDimensions.paddingXL,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _isProcessing ? null : _scanBarcodePhoto,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scanDocument() async {
    setState(() => _isProcessing = true);
    try {
      final result = await _mlKitService.scanDocument();
      if (result != null && mounted) {
        // Handle the scanned document result
        // The API might have changed, let's check what properties are available
        await _processScannedDocument(result);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error scanning document: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile photo = await _cameraController!.takePicture();
      if (mounted) {
        await _processPhoto(photo.path, 'photo');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error taking photo: $e');
      }
    }
  }

  Future<void> _pickPhotoFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null && mounted) {
        await _processPhoto(image.path, 'gallery');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error picking image: $e');
      }
    }
  }

  Future<void> _onHandwritingRecognized(String text) async {
    setState(() => _isProcessing = true);
    try {
      // Save note
      final note = Note(
        noteId: const Uuid().v4(),
        title: 'Handwritten Note ${DateTime.now().day}',
        content: text,
        subject: 'General',
        noteType: NoteTypes.handwritten,
        handwritingImagePath: null,
        thumbnailPath: null,
        tags: [],
      );
      await _databaseService.addNote(note);

      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Note digitized successfully');
        setState(() => _selectedMode = null);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error processing note: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _scanBarcodePhoto() async {
    try {
      final XFile photo = await _cameraController!.takePicture();
      if (mounted) {
        await _processBarcodePhoto(photo.path);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error scanning barcode: $e');
      }
    }
  }

  Future<void> _processScannedDocument(DocumentScanningResult result) async {
    setState(() => _isProcessing = true);
    try {
      // Get the first scanned image
      final images = result.images ?? <String>[];
      if (images.isEmpty) {
        throw Exception('No images found in scan result');
      }

      final imagePath = images.first;

      // Extract text
      final text = await _mlKitService.recognizeTextFromFile(imagePath);

      // Get categories
      final categories = await _mlKitService.categorizeDocument(imagePath);
      final subject = categories.isNotEmpty ? categories.first : 'General';

      // Create thumbnail
      final thumbnail = await _mlKitService.createThumbnail(imagePath);

      // Get file size
      final fileSize = await FileUtilities.getFileSize(imagePath);

      // Save document
      final document = Document(
        documentId: const Uuid().v4(),
        title: 'Scanned Document ${DateTime.now().day}',
        subject: subject,
        filePath: imagePath,
        fileName: File(imagePath).uri.pathSegments.last,
        documentType: DocumentTypes.textbook,
        extractedText: [text],
        thumbnailPath: thumbnail,
        fileSize: fileSize,
        tags: categories,
      );

      await _databaseService.addDocument(document);

      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Document scanned successfully');
        setState(() => _selectedMode = null);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error processing document: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _processPhoto(String imagePath, String source) async {
    setState(() => _isProcessing = true);
    try {
      // Extract text
      final text = await _mlKitService.recognizeTextFromFile(imagePath);

      // Get categories
      final categories = await _mlKitService.categorizeDocument(imagePath);
      final subject = categories.isNotEmpty ? categories.first : 'General';

      // Create thumbnail
      final thumbnail = await _mlKitService.createThumbnail(imagePath);

      // Get file size
      final fileSize = await FileUtilities.getFileSize(imagePath);

      // Save document
      final document = Document(
        documentId: const Uuid().v4(),
        title: 'Photo ${DateTime.now().day}',
        subject: subject,
        filePath: imagePath,
        fileName: File(imagePath).uri.pathSegments.last,
        documentType: DocumentTypes.image,
        extractedText: text.isNotEmpty ? [text] : [],
        thumbnailPath: thumbnail,
        fileSize: fileSize,
        tags: categories,
      );

      await _databaseService.addDocument(document);

      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Photo processed successfully');
        setState(() => _selectedMode = null);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error processing photo: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _processBarcodePhoto(String imagePath) async {
    setState(() => _isProcessing = true);
    try {
      // Extract ISBN from barcode
      final isbn = await _mlKitService.extractISBNFromBarcode(imagePath);

      if (isbn != null && mounted) {
        // Navigate to book details screen to add book
        Navigator.pushNamed(
          context,
          '/book_editor',
          arguments: {'isbn': isbn, 'coverImagePath': imagePath},
        );
      } else if (mounted) {
        SnackBarHelper.showError(context, 'Could not read ISBN from barcode');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error scanning barcode: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Widget _buildCaptureOption(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: AppDimensions.iconXL),
            const SizedBox(width: AppDimensions.paddingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFonts.fontSize16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: AppFonts.fontSize12,
                      color: color.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: color),
          ],
        ),
      ),
    );
  }
}
