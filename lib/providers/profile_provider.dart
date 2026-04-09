import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../data/models/api_response.dart';
import '../data/models/user_model.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  XFile? _selectedImage;
  String? _base64Image;

  bool get isLoading => _isLoading;
  XFile? get selectedImage => _selectedImage;
  String? get base64Image => _base64Image;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _selectedImage = image;
      _isLoading = true;
      notifyListeners();

      final Uint8List imageBytes = await image.readAsBytes();
      _base64Image = await compute(_processImage, imageBytes);

      _isLoading = false;
      notifyListeners();
    }
  }

  static String _processImage(Uint8List rawBytes) {
    img.Image? decoded = img.decodeImage(rawBytes);
    if (decoded == null) return base64Encode(rawBytes);

    img.Image resized = img.copyResize(decoded, width: 600, height: 600);

    int quality = 80;
    Uint8List compressed = Uint8List.fromList(img.encodeJpg(resized, quality: quality));

    while (compressed.lengthInBytes > 50 * 1024 && quality > 5) {
      quality -= 10;
      compressed = Uint8List.fromList(img.encodeJpg(resized, quality: quality));
    }

    return base64Encode(compressed);
  }

  Future<ApiResponse> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String? password,
    required String? token,
  }) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "photo": _base64Image ?? "",
    };

    if (password != null && password.isNotEmpty) {
      requestBody['password'] = password;
    }

    _isLoading = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.ProfileUpdateURL,
      body: requestBody,
      token: token,
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }

  Future<UserModel?> fetchProfileDetails(String? token) async {
    final ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.ProfileDetailsURL,
      token: token,
    );

    if (response.isSuccess && response.responseData != null) {
      final data = response.responseData['data'];
      if (data != null && data is List && data.isNotEmpty) {
        return UserModel.fromJson(data[0]);
      }
    }
    return null;
  }

  void clearSelectedImage() {
    _selectedImage = null;
    _base64Image = null;
    notifyListeners();
  }
}