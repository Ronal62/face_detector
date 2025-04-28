import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/face_data.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<FaceData> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<FaceData>('faces');
  }

  @override
  Widget build(BuildContext context) {
    int totalFaces = _box.length;

    return Scaffold(
      appBar: AppBar(title: Text("Face Detector")),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.face, size: 50, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      'Total Wajah Tersimpan',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$totalFaces',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
