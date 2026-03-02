import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApplication',
      debugShowCheckedModeBanner: false,
      home: DocumentScreen(),
    );
  }
}

class DocumentScreen extends StatelessWidget {
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
                      height: 55,
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
                          suffixIcon: Icon(
                            Icons.mic,
                            color: Colors.grey,
                            size: 28,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    " All(5)",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(115, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.create_new_folder_outlined, color: Colors.teal[300]),
                SizedBox(width: 15),
                Icon(Icons.swap_vert, color: Colors.teal[300]),
                SizedBox(width: 8),
                Icon(Icons.list, color: Colors.teal[300], size: 28),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildFolderItem(
                    "My Private Folder 05-24-2022 12.52",
                    "25/05/2022 03:44",
                    "0 Files",
                  ),
                  _buildDocItem(
                    "New Doc 05-24-2022 12.52",
                    "25/05/2022 10:52",
                    3,
                    true,
                  ),
                  _buildDocItem(
                    "New Doc 05-24-2022 09.49",
                    "24/05/2022 10:27",
                    2,
                    false,
                    tags: ["Business Card", "pdf doc"],
                  ),
                  _buildDocItem(
                    "New Doc 05-19-2022 16.06",
                    "20/05/2022 16:41",
                    2,
                    false,
                  ),
                  _buildDocItem(
                    "New Doc 05-24-2022 12.52",
                    "25/05/2022 10:52",
                    3,
                    true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            backgroundColor: Colors.teal[400],
            onPressed: () {},
            child: const Icon(Icons.description, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.teal[600],
            onPressed: () {},
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 35),
          ),
        ],
      ),
    );
  }
}

Widget _buildFolderItem(String title, String data, String count) {
  return ListTile(
    leading: Container(
      width: 100,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.folder, size: 50, color: Colors.teal.shade400),
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    subtitle: Text("Accessed: $data\n$count", style: TextStyle(fontSize: 14)),
    trailing: Icon(Icons.more_vert),
  );
}

Widget _buildDocItem(
  String title,
  String date,
  int pages,
  bool isScanned, {
  List<String>? tags,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      leading: Container(
        width: 100,
        height: 350,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/2.png'),
            fit: BoxFit.cover,
          ),
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Accessed: $date", style: const TextStyle(fontSize: 14)),
          Row(
            children: [
              Icon(Icons.copy_all, size: 16, color: Colors.grey[400]),
              Text(" $pages", style: const TextStyle(fontSize: 11)),
              if (tags != null)
                ...tags
                    .map(
                      (tag) => Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(tag, style: const TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
            ],
          ),
        ],
      ),
      trailing: const Icon(Icons.more_vert),
    ),
  );
}
