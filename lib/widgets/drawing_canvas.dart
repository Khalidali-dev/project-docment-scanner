import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;

class DrawingCanvas extends StatefulWidget {
  final Function(String) onTextRecognized;

  const DrawingCanvas({super.key, required this.onTextRecognized});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  final mlkit.DigitalInkRecognizer _recognizer = mlkit.DigitalInkRecognizer(
    languageCode: 'en',
  );

  @override
  void dispose() {
    _recognizer.close();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _strokes.add(List.from(_currentStroke));
      _currentStroke = [];
    });
  }

  Future<void> _recognizeText() async {
    if (_strokes.isEmpty) return;

    try {
      final List<mlkit.Stroke> mlkitStrokes = _strokes.map((stroke) {
        final List<mlkit.StrokePoint> points = stroke.map((offset) {
          return mlkit.StrokePoint(
            x: offset.dx,
            y: offset.dy,
            t: DateTime.now().millisecondsSinceEpoch,
          );
        }).toList();
        return mlkit.Stroke()..points = points;
      }).toList();

      final mlkit.Ink ink = mlkit.Ink()..strokes = mlkitStrokes;
      final List<mlkit.RecognitionCandidate> candidates = await _recognizer
          .recognize(ink);

      if (candidates.isNotEmpty) {
        widget.onTextRecognized(candidates.first.text);
      } else {
        widget.onTextRecognized('');
      }
    } catch (e) {
      log('Error recognizing handwriting: $e');
      widget.onTextRecognized('');
    }
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: DrawingPainter(
                  strokes: _strokes,
                  currentStroke: _currentStroke,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: _clear, child: const Text('Clear')),
            ElevatedButton(
              onPressed: _recognizeText,
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  DrawingPainter({required this.strokes, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (final stroke in strokes) {
      if (stroke.length > 1) {
        for (int i = 0; i < stroke.length - 1; i++) {
          canvas.drawLine(stroke[i], stroke[i + 1], paint);
        }
      }
    }

    if (currentStroke.length > 1) {
      for (int i = 0; i < currentStroke.length - 1; i++) {
        canvas.drawLine(currentStroke[i], currentStroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return true;
  }
}
