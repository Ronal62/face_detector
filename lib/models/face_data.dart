import 'package:hive/hive.dart';
part 'face_data.g.dart';

@HiveType(typeId: 0)
class FaceData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String imagePath;

  FaceData({required this.name, required this.imagePath});
}
