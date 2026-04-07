import 'package:flutter/material.dart';
import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<ApiResponse> signIn(String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    _isLoading = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.LoginUrl,
      body: requestBody,
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }
}
