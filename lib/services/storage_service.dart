import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StorageService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera
  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  String _determineContentType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  /// Upload image to Firebase Storage with robust multi-tier fallback
  Future<String?> uploadImage(XFile file) async {
    final cleanName = file.name.replaceAll(RegExp(r'[^a-zA-Z0-9\._-]'), '_');
    final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}_$cleanName';
    final Uint8List bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      debugPrint('Selected image file is empty.');
      return null;
    }

    // Tier 1: Firebase Storage Upload
    try {
      final contentType = file.mimeType ?? _determineContentType(file.name);
      final metadata = SettableMetadata(contentType: contentType);
      final storageRef = FirebaseStorage.instance.ref().child('products/$fileName');

      final TaskSnapshot snapshot = await storageRef.putData(bytes, metadata).timeout(
        const Duration(seconds: 4),
      );
      final downloadUrl = await snapshot.ref.getDownloadURL();
      if (downloadUrl.isNotEmpty) {
        debugPrint('Uploaded to Firebase Storage successfully: $downloadUrl');
        return downloadUrl;
      }
    } catch (firebaseErr) {
      debugPrint('Firebase Storage upload notice/fallback: $firebaseErr');
    }

    // Tier 2: ImgBB Multipart Upload API
    try {
      const apiKey = '6d00371086f05b61279232249ea5f720';
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: fileName,
        ),
      );
      final streamedResponse = await request.send().timeout(const Duration(seconds: 10));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null && data['data']['url'] != null) {
          final url = data['data']['url'] as String;
          debugPrint('Uploaded to ImgBB successfully: $url');
          return url;
        }
      }
    } catch (imgbbErr) {
      debugPrint('ImgBB Multipart upload notice: $imgbbErr');
    }

    // Tier 3: Data URL fallback for guaranteed preview & storage in Firestore
    try {
      final contentType = file.mimeType ?? _determineContentType(file.name);
      final base64Str = base64Encode(bytes);
      final dataUrl = 'data:$contentType;base64,$base64Str';
      debugPrint('Generated Data URL fallback for image.');
      return dataUrl;
    } catch (dataUrlErr) {
      debugPrint('Data URL encoding error: $dataUrlErr');
    }

    return null;
  }
}
