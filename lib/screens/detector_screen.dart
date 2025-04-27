import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'
    as mlkit;
import 'package:hive/hive.dart';
import '../models/face_data.dart';
import '../widgets/app_drawer.dart';

class DetectorScreen extends StatefulWidget {
  @override
  _DetectorScreenState createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  CameraController? _cameraController;
  mlkit.FaceDetector? _faceDetector;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    _initializeCameraAndDetector();
  }

  Future<void> _initializeCameraAndDetector() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();

    _faceDetector = mlkit.FaceDetector(
      options: mlkit.FaceDetectorOptions(
        performanceMode: mlkit.FaceDetectorMode.accurate,
      ),
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  Future<void> _scanAndMatchFace() async {
    if (!_cameraController!.value.isInitialized ||
        _cameraController!.value.isTakingPicture) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _result = '';
    });

    final picture = await _cameraController!.takePicture();
    final inputImage = mlkit.InputImage.fromFilePath(picture.path);
    final faces = await _faceDetector!.processImage(inputImage);

    if (faces.isEmpty) {
      setState(() {
        _result = "Tidak ada wajah terdeteksi!";
        _isProcessing = false;
      });
      return;
    }

    final box = Hive.box<FaceData>('faces');
    bool found = false;

    for (int i = 0; i < box.length; i++) {
      FaceData faceData = box.getAt(i)!;
      final savedImage = mlkit.InputImage.fromFilePath(faceData.imagePath);
      final savedFaces = await _faceDetector!.processImage(savedImage);

      if (savedFaces.isNotEmpty) {
        // Matching sederhana: asal dua gambar sama-sama ada wajah
        found = true;
        setState(() {
          _result = "Halo, ${faceData.name}!";
          _isProcessing = false;
        });
        break;
      }
    }

    if (!found) {
      setState(() {
        _result = "Wajah tidak dikenal!";
        _isProcessing = false;
      });
    }

    // Hapus foto sementara
    File(picture.path).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detector")),
      drawer: AppDrawer(),
      body:
          _isInitialized
              ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _scanAndMatchFace,
                    child:
                        _isProcessing
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Scan dan Cocokkan Wajah"),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
