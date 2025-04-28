import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'
    as mlkit;
import 'package:hive/hive.dart';
import '../models/face_data.dart';
import '../widgets/app_drawer.dart';

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key});

  @override
  _DetectorScreenState createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  CameraController? _cameraController;
  mlkit.FaceDetector? _faceDetector;
  bool _isInitialized = false;
  bool _isScanning = false;
  bool _isFaceFound = false;
  String _result = 'Scanning...';
  Timer? _scanTimer;

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

    _startScanning();
  }

  @override
  void dispose() {
    _stopScanning();
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  void _startScanning() {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _isFaceFound = false;
      _result = 'Scanning...';
    });

    _scanTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (!_isScanning) {
        timer.cancel();
        return;
      }
      await _scanAndMatchFace();
    });
  }

  void _stopScanning() {
    if (_scanTimer != null) {
      _scanTimer!.cancel();
      _scanTimer = null;
    }
    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _scanAndMatchFace() async {
    if (!_cameraController!.value.isInitialized ||
        _cameraController!.value.isTakingPicture) {
      return;
    }

    final picture = await _cameraController!.takePicture();
    final inputImage = mlkit.InputImage.fromFilePath(picture.path);
    final faces = await _faceDetector!.processImage(inputImage);

    if (faces.isEmpty) {
      setState(() {
        _result = "Tidak ada wajah terdeteksi!";
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
        found = true;
        setState(() {
          _result = "Wajah Terdeteksi!";
          _isFaceFound = true;
        });
        break;
      }
    }

    if (!found) {
      setState(() {
        _result = "Wajah tidak dikenal!";
      });
    } else {
      _stopScanning();
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
                  Text(
                    _result,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  if (_isFaceFound)
                    ElevatedButton(
                      onPressed: _startScanning,
                      child: Text("Rescan"),
                    ),
                ],
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
