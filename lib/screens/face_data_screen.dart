import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/face_data.dart';
import '../widgets/app_drawer.dart';

class FaceDataScreen extends StatefulWidget {
  @override
  _FaceDataScreenState createState() => _FaceDataScreenState();
}

class _FaceDataScreenState extends State<FaceDataScreen> {
  late Box<FaceData> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<FaceData>('faces');
  }

  void _deleteFace(int index) async {
    final face = _box.getAt(index);
    if (face != null && File(face.imagePath).existsSync()) {
      await File(face.imagePath).delete();
    }
    await _box.deleteAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data wajah '${face?.name}' dihapus")),
    );
  }

  void _editFace(int index) {
    final face = _box.getAt(index);
    final controller = TextEditingController(text: face?.name);
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text("Edit Nama"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Nama Baru"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    final updated = FaceData(
                      name: controller.text,
                      imagePath: face!.imagePath,
                    );
                    _box.putAt(index, updated);
                    setState(() {});
                    Navigator.pop(ctx);
                  }
                },
                child: Text("Simpan"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faces = _box.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Face Data")),
      drawer: AppDrawer(),
      body:
          faces.isEmpty
              ? Center(child: Text("Belum ada data wajah."))
              : ListView.builder(
                itemCount: faces.length,
                itemBuilder: (context, index) {
                  final face = faces[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FileImage(File(face.imagePath)),
                        radius: 30,
                      ),
                      title: Text(face.name),
                      subtitle: Text("Tap nama untuk edit"),
                      onTap: () => _editFace(index),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteFace(index),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
