import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(XFile image) async {
    try {
      // şəkillər üçün idlər yaradırıq
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('images').child(fileName);

      // şəkili yüklə
      UploadTask uploadTask = ref.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;

      // şəkillər yükləndikdən sonra urllər alırıq

      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Şəkli yükləyəndə xəta baş verdi: $e');
      return null;
    }
  }
}
