import 'package:flutter/material.dart';
import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<ApiResponse> verifyEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.RecoverVerifyEmail(email),
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }

  Future<ApiResponse> verifyOtp(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.RecoverVerifyOTP(email, otp),
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }

  Future<ApiResponse> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> body = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.RecoverResetPass,
      body: body,
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }
}
