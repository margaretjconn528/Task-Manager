import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../data/models/api_response.dart';
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
      imageQuality: 25,
    );

    if (image != null) {
      _selectedImage = image;
      List<int> imageBytes = await image.readAsBytes();
      _base64Image = base64Encode(imageBytes);
      notifyListeners();
    }
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
      "photo": "",
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

  void clearSelectedImage() {
    _selectedImage = null;
    _base64Image = null;
    notifyListeners();
  }
}
