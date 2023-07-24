import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String filePath) async {
    try {
      final storageRef = _storage.ref().child(filePath);
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to upload file: $e');
      return null;
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final storageRef = _storage.ref().child(filePath);
      await storageRef.delete();
    } catch (e) {
      print('Failed to delete file: $e');
    }
  }
}
