import 'package:flutter/material.dart';
import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

/// Provider responsible for handling "Forgot Password" workflow.
///
/// Responsibilities:
/// - Verify user email
/// - Verify OTP (One-Time Password)
/// - Reset user password
/// - Manage loading state for UI feedback
class ForgotPasswordProvider extends ChangeNotifier {
  /// Private loading state to indicate API call progress
  bool _isLoading = false;

  /// Public getter for loading state (used in UI)
  bool get isLoading => _isLoading;

  /// Step 1: Verify if the provided email exists in the system
  ///
  /// [email] - User's registered email address
  ///
  /// Returns:
  /// - [ApiResponse] containing API result
  Future<ApiResponse> verifyEmail(String email) async {
    /// Enable loading before API call
    _isLoading = true;
    notifyListeners();

    /// Send GET request to verify email
    ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.RecoverVerifyEmail(email),
    );

    /// Disable loading after API call completes
    _isLoading = false;
    notifyListeners();

    return response;
  }

  /// Step 2: Verify OTP sent to the user's email
  ///
  /// [email] - User's email
  /// [otp] - One-Time Password received by user
  ///
  /// Returns:
  /// - [ApiResponse] containing verification result
  Future<ApiResponse> verifyOtp(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    /// Send GET request to verify OTP
    ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.RecoverVerifyOTP(email, otp),
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }

  /// Step 3: Reset the user's password after OTP verification
  ///
  /// Parameters:
  /// - [email]: User's email
  /// - [otp]: Verified OTP
  /// - [password]: New password to set
  ///
  /// Returns:
  /// - [ApiResponse] containing reset result
  Future<ApiResponse> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    /// Request body for password reset API
    Map<String, dynamic> body = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    /// Send POST request to reset password
    ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.RecoverResetPass,
      body: body,
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }
}