import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  static const String _accessTokenKey = 'token';
  static const String _userModelKey = 'user-data';
  final Logger _logger = Logger();

  String? _accessToken;
  UserModel? _userModel;

  String? get accessToken => _accessToken;
  UserModel? get userModel => _userModel;
  bool get isLoggedIn => _accessToken != null;

  Future<void> saveUserData(UserModel model, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    await prefs.setString(_userModelKey, jsonEncode(model.toJson()));
    _accessToken = token;
    _userModel = model;
    _logger.i(_accessToken);
    _logger.i(_userModel);
    notifyListeners();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_accessTokenKey);
    if (token != null) {
      _accessToken = token;
      String? userData = prefs.getString(_userModelKey);
      _userModel = UserModel.fromJson(jsonDecode(userData!));
    }
    _logger.i(token);
    _logger.i(_userModel);
    notifyListeners();
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_accessTokenKey);
    if (token != null) {
      _accessToken = token;
      String? userData = prefs.getString(_userModelKey);
      if (userData != null) {
        _userModel = UserModel.fromJson(jsonDecode(userData));
      }
      notifyListeners();
    }
    return token != null;
  }

  Future<void> updateUserData(UserModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userModelKey, jsonEncode(model.toJson()));
    _userModel = model;
    notifyListeners();
  }

  Future<void> cleanUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _accessToken = null;
    _userModel = null;
    notifyListeners();
  }
}
