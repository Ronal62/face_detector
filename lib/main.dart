import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_face_screen.dart';
import 'screens/detector_screen.dart';
import 'screens/face_data_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/face_data.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FaceDataAdapter()); // <- ini penting!
  await Hive.openBox<FaceData>('faces'); // <- box untuk wajah
  runApp(FaceDetectorApp());
}

class FaceDetectorApp extends StatelessWidget {
  const FaceDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detector',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      routes: {
        '/home': (_) => HomeScreen(),
        '/add': (_) => AddFaceScreen(),
        '/detect': (_) => DetectorScreen(),
        '/data': (_) => FaceDataScreen(), 
      },
    );
  }
}
