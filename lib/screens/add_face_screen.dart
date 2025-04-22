import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/face_data.dart';
import '../widgets/app_drawer.dart';

class AddFaceScreen extends StatefulWidget {
  @override
  _AddFaceScreenState createState() => _AddFaceScreenState();
}

class _AddFaceScreenState extends State<AddFaceScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
      );
      await _cameraController!.initialize();
      setState(() => _isCameraReady = true);
    } catch (e) {
      print("❌ Error init kamera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _captureAndSaveFace() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Nama wajib diisi!")));
      return;
    }

    try {
      setState(() => _isSaving = true);

      final image = await _cameraController!.takePicture();
      final appDir = await getApplicationDocumentsDirectory();
      final savedImage = await File(
        image.path,
      ).copy('${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final face = FaceData(
        name: _nameController.text,
        imagePath: savedImage.path,
      );

      if (!Hive.isBoxOpen('faces')) {
        await Hive.openBox<FaceData>('faces');
      }

      final box = Hive.box<FaceData>('faces');
      await box.add(face);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wajah ${face.name} berhasil disimpan!")),
      );

      _nameController.clear();
    } catch (e) {
      print("❌ Gagal simpan wajah: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat menyimpan wajah.")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Face")),
      drawer: AppDrawer(),
      body:
          _isCameraReady
              ? SingleChildScrollView(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: CameraPreview(_cameraController!),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Wajah',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    _isSaving
                        ? CircularProgressIndicator()
                        : ElevatedButton.icon(
                          onPressed: _captureAndSaveFace,
                          icon: Icon(Icons.save),
                          label: Text("Simpan Wajah"),
                        ),
                  ],
                ),
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
