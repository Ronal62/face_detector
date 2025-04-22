// detector_screen.dart
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class DetectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Detector")),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Halaman deteksi wajah', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
