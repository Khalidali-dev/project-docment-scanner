import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  PreviewScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanned Preview"),
        backgroundColor: Color(0xFF338D76),
      ),
      body: Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),
    );
  }
}
