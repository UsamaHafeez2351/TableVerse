import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../constants/app_constants.dart';

/// Storage service for Firebase Storage
class StorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();
  static StorageService get instance => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // ==================== Image Upload ====================

  /// Upload image from file
  Future<String> uploadImage({
    required File imageFile,
    required String path,
    String? fileName,
  }) async {
    try {
      final name = fileName ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('$path/$name');

      final uploadTask = await ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image');
    }
  }

  /// Upload image from image picker
  Future<String?> pickAndUploadImage({
    required String path,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: AppConstants.maxImageWidth.toDouble(),
        maxHeight: AppConstants.maxImageHeight.toDouble(),
      );

      if (image == null) return null;

      final file = File(image.path);
      return await uploadImage(
        imageFile: file,
        path: path,
      );
    } catch (e) {
      throw Exception('Failed to pick and upload image');
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadImages({
    required List<File> imageFiles,
    required String path,
  }) async {
    try {
      final urls = <String>[];
      for (final file in imageFiles) {
        final url = await uploadImage(
          imageFile: file,
          path: path,
        );
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw Exception('Failed to upload images');
    }
  }

  // ==================== 3D Model Upload ====================

  /// Upload 3D model (.glb/.gltf)
  Future<String> upload3DModel({
    required File modelFile,
    required String path,
    String? fileName,
  }) async {
    try {
      final name = fileName ?? '${DateTime.now().millisecondsSinceEpoch}.glb';
      final ref = _storage.ref().child('$path/$name');

      final uploadTask = await ref.putFile(
        modelFile,
        SettableMetadata(
          contentType: 'model/gltf-binary',
        ),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload 3D model');
    }
  }

  /// Pick and upload 3D model
  Future<String?> pickAndUpload3DModel({
    required String path,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['glb', 'gltf'],
        withData: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = File(result.files.first.path!);
      return await upload3DModel(
        modelFile: file,
        path: path,
      );
    } catch (e) {
      throw Exception('Failed to pick and upload 3D model');
    }
  }

  // ==================== File Operations ====================

  /// Delete file
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file');
    }
  }

  /// Delete multiple files
  Future<void> deleteFiles(List<String> fileUrls) async {
    try {
      for (final url in fileUrls) {
        await deleteFile(url);
      }
    } catch (e) {
      throw Exception('Failed to delete files');
    }
  }

  // ==================== Helper Methods ====================

  /// Get file size
  Future<int> getFileSize(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      final metadata = await ref.getMetadata();
      return metadata.size ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if file exists
  Future<bool> fileExists(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }
}
