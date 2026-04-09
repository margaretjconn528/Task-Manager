import 'package:flutter/material.dart';
import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

/// Provider responsible for handling user registration (Sign Up).
///
/// Responsibilities:
/// - Send registration data to backend
/// - Manage loading state for UI feedback
class SignUpProvider extends ChangeNotifier {
  /// Indicates whether an API request is in progress
  bool _isLoading = false;

  /// Public getter for loading state
  bool get isLoading => _isLoading;

  /// Sends sign-up request to the server
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [firstName]: User's first name
  /// - [lastName]: User's last name
  /// - [mobile]: User's phone number
  /// - [password]: User's password
  ///
  /// Returns:
  /// - [ApiResponse] containing registration result
  Future<ApiResponse> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async {
    /// Request payload for registration API
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    /// Enable loading state before API call
    _isLoading = true;
    notifyListeners();

    /// Perform POST request to register user
    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.SignUpURL,
      body: requestBody,
    );

    /// Disable loading state after API call completes
    _isLoading = false;
    notifyListeners();

    /// Return API response to UI layer
    return response;
  }
}