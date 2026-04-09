import 'package:flutter/material.dart';
import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';

/// Provider responsible for handling "Add Task" operations.
///
/// Manages:
/// - API call for creating a new task
/// - Loading state for UI feedback
class AddTaskProvider extends ChangeNotifier {
  /// Private loading state to control UI indicators (e.g., loader/spinner)
  bool _isLoading = false;

  /// Public getter to expose loading state to the UI
  bool get isLoading => _isLoading;

  /// Sends a request to create a new task
  ///
  /// Parameters:
  /// - [title]: Title of the task
  /// - [description]: Detailed description of the task
  /// - [token]: Authorization token for secure API access
  ///
  /// Returns:
  /// - [ApiResponse] containing success status and response data
  Future<ApiResponse> addTask({
    required String title,
    required String description,
    required String? token,
  }) async {
    /// Request payload sent to backend API
    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,

      /// Default status when a task is created
      "status": "New",
    };

    /// Enable loading state before API call
    _isLoading = true;
    notifyListeners();

    /// Perform POST request to create task
    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.AddTaskURL,
      body: requestBody,
      token: token,
    );

    /// Disable loading state after API call completes
    _isLoading = false;
    notifyListeners();

    /// Return API response to caller (UI / ViewModel)
    return response;
  }
}