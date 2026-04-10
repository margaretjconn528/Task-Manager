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

/// Provider class for managing user profile operations.
/// 
/// Handles image picking, profile updates, and fetching user details.
class ProfileProvider extends ChangeNotifier {
  /// Whether an ongoing profile operation is in progress.
  bool _isLoading = false;

  /// The currently selected image file from the picker.
  XFile? _selectedImage;

  /// The base64 encoded string of the processed profile image.
  String? _base64Image;

  /// Returns true if an operation is currently loading.
  bool get isLoading => _isLoading;

  /// Returns the selected image file.
  XFile? get selectedImage => _selectedImage;

  /// Returns the base64 string of the selected image.
  String? get base64Image => _base64Image;

  /// Internal instance of ImagePicker for selecting images.
  final ImagePicker _imagePicker = ImagePicker();

  /// Launches the image picker and processes the selected image.
  /// 
  /// Updates [selectedImage] and generates a base64 encoded version in the background.
  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _selectedImage = image;
      _isLoading = true;
      notifyListeners();

      final Uint8List imageBytes = await image.readAsBytes();
      // Offload image processing to a background isolate to keep UI responsive.
      _base64Image = await compute(_processImage, imageBytes);

      _isLoading = false;
      notifyListeners();
    }
  }

  /// Internal helper to resize and compress images before base64 encoding.
  /// 
  /// Decodes the raw bytes, resizes to a max of 600x600, and reduces quality
  /// until the image size is under 50KB or minimum quality is reached.
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

  /// Updates the user's profile information via the API.
  /// 
  /// Takes user details and sends them to the server. Includes the selected image
  /// if one has been picked.
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

  /// Fetches the current user's profile details from the server.
  /// 
  /// Returns a [UserModel] if successful, or null otherwise.
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

  /// Resets the selected image and base64 cache.
  void clearSelectedImage() {
    _selectedImage = null;
    _base64Image = null;
    notifyListeners();
  }
}