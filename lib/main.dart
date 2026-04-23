import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'document_screen.dart';
import 'preview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApplication',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DocumentScanner _scanner;

  @override
  void initState() {
    super.initState();
    _scanner = DocumentScanner(
      options: DocumentScannerOptions(
        mode: ScannerMode.full,
        pageLimit: 1,
        isGalleryImport: true,
      ),
    );
  }

  Future<void> scanDocument() async {
    try {
      final result = await _scanner.scanDocument();

      // ignore: unnecessary_null_comparison
      if (result != null &&
          result.images != null &&
          result.images!.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PreviewScreen(imagePath: result.images!.first),
          ),
        );
      }
    } catch (e) {
      print("Error scanning document: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error scanning document: $e')));
    }
  }

  @override
  void dispose() {
    _scanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        border: Border.all(
                          color: const Color.fromARGB(255, 243, 242, 242),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Here',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 233, 232, 232),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: const Color.fromARGB(255, 204, 203, 203),
                            size: 26,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Image.asset('assets/01.png', height: 60, width: 60),
                ],
              ),
            ),
            SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 6,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildMenuIcon(
                  Icons.document_scanner_outlined,
                  "Smart Scan",
                  Colors.blue.shade50,
                  Colors.blue,
                ),
                _buildMenuIcon(
                  Icons.image_outlined,
                  "Import Images",
                  Colors.green.shade50,
                  Colors.green,
                ),
                _buildMenuIcon(
                  Icons.file_upload_outlined,
                  "Import Files",
                  Colors.blue.shade100,
                  Colors.blueAccent,
                ),
                _buildMenuIcon(
                  Icons.badge_outlined,
                  "ID Card",
                  Colors.blue.shade50,
                  Colors.blue,
                ),
                _buildMenuIcon(
                  Icons.text_fields,
                  "To Text",
                  Colors.teal.shade50,
                  Colors.teal,
                ),
                _buildMenuIcon(
                  Icons.table_chart_outlined,
                  "To Excel",
                  Colors.green.shade50,
                  Colors.green,
                ),
                _buildMenuIcon(
                  Icons.draw_outlined,
                  "PDF Signature",
                  Colors.purple.shade50,
                  Colors.purple,
                ),
                _buildMenuIcon(
                  Icons.grid_view_rounded,
                  "All",
                  Colors.red.shade50,
                  Colors.redAccent,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.all(20.0)),
                Text(
                  'Recent Docs',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 56, 56, 56),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 75),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No recent File',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 60),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: const Color.fromARGB(255, 72, 156, 121),
                          width: 1.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Scan new docs',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 72, 156, 121),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanDocument,
        backgroundColor: const Color.fromARGB(255, 51, 141, 118),
        shape: CircleBorder(),
        child: Icon(Icons.camera_alt, color: Colors.white, size: 30),
      ),
    );
  }
}

Widget _buildMenuIcon(
  IconData icon,
  String label,
  Color bgColor,
  Color iconColor,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 28),
      ),
      SizedBox(height: 8),
      Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    ],
  );
}
