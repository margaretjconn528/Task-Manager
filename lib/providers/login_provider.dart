import 'package:flutter/material.dart';
import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

/// Provider responsible for handling user authentication (Login).
///
/// Responsibilities:
/// - Perform login API request
/// - Manage loading state for UI feedback
class LoginProvider extends ChangeNotifier {
  /// Private loading state to indicate API call progress
  bool _isLoading = false;

  /// Public getter to expose loading state to UI
  bool get isLoading => _isLoading;

  /// Sends login request to the server
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  ///
  /// Returns:
  /// - [ApiResponse] containing login result (token, user data, etc.)
  Future<ApiResponse> signIn(String email, String password) async {
    /// Request payload for login API
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    /// Enable loading state before API call
    _isLoading = true;
    notifyListeners();

    /// Perform POST request for authentication
    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.LoginUrl,
      body: requestBody,
    );

    /// Disable loading state after API call completes
    _isLoading = false;
    notifyListeners();

    /// Return API response to UI layer
    return response;
  }
}