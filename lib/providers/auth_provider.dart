import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

/// Provider responsible for handling authentication state
/// and user session persistence.
///
/// Responsibilities:
/// - Store and retrieve access token
/// - Store and retrieve user data
/// - Maintain login state
/// - Handle logout / session cleanup
class AuthProvider extends ChangeNotifier {
  /// Key used to store access token in local storage
  static const String _accessTokenKey = 'token';

  /// Key used to store user model JSON in local storage
  static const String _userModelKey = 'user-data';

  /// Logger instance for debugging and tracking
  final Logger _logger = Logger();

  /// Private access token
  String? _accessToken;

  /// Cached user model
  UserModel? _userModel;

  /// Public getter for access token
  String? get accessToken => _accessToken;

  /// Public getter for user data
  UserModel? get userModel => _userModel;

  /// Indicates whether the user is logged in
  bool get isLoggedIn => _accessToken != null;

  /// Saves user data and token to local storage
  ///
  /// This method is typically called after successful login/registration.
  Future<void> saveUserData(UserModel model, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Persist token and user data
    await prefs.setString(_accessTokenKey, token);
    await prefs.setString(_userModelKey, jsonEncode(model.toJson()));

    /// Update in-memory state
    _accessToken = token;
    _userModel = model;

    /// Log for debugging purposes
    _logger.i(_accessToken);
    _logger.i(_userModel);

    notifyListeners();
  }

  /// Retrieves user data and token from local storage
  ///
  /// Used during app startup to restore session
  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Fetch stored token
    String? token = prefs.getString(_accessTokenKey);

    if (token != null) {
      _accessToken = token;

      /// Fetch and decode user data
      String? userData = prefs.getString(_userModelKey);
      _userModel = UserModel.fromJson(jsonDecode(userData!));
    }

    /// Logging restored data
    _logger.i(token);
    _logger.i(_userModel);

    notifyListeners();
  }

  /// Checks whether the user is currently logged in
  ///
  /// Also restores in-memory state if data exists in storage
  ///
  /// Returns:
  /// - true if logged in
  /// - false otherwise
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(_accessTokenKey);

    if (token != null) {
      _accessToken = token;

      /// Restore user data if available
      String? userData = prefs.getString(_userModelKey);
      if (userData != null) {
        _userModel = UserModel.fromJson(jsonDecode(userData));
      }

      notifyListeners();
    }

    return token != null;
  }

  /// Updates user information in local storage and memory
  ///
  /// Typically used when user updates profile
  Future<void> updateUserData(UserModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Save updated user data
    await prefs.setString(_userModelKey, jsonEncode(model.toJson()));

    /// Update in-memory model
    _userModel = model;

    notifyListeners();
  }

  /// Clears all user-related data (logout)
  ///
  /// Removes:
  /// - Access token
  /// - User model
  Future<void> cleanUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Clear all stored preferences
    await prefs.clear();

    /// Reset in-memory state
    _accessToken = null;
    _userModel = null;

    notifyListeners();
  }
}
