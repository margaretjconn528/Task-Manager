import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

/// A controller class responsible for managing user authentication state and persistence.
class AuthController{
    // Key for storing access token in SharedPreferences
    static String _accessTokenKey = 'token';
    
    // Key for storing user data in SharedPreferences
    static String _userModelKey = 'user-data';
    
    // Logger instance for debugging and tracking authentication flow
    static final Logger _logger = Logger();

    // Variable to hold the current access token in memory
    static String ? accessToken;
    
    // Variable to hold the current user model in memory
    static UserModel ? userModel;

    /// Saves user data and access token to both local storage and memory.
    static Future saveUserData(UserModel model,String token) async {
        // Get SharedPreferences instance
        SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
        
        // Store the access token
        await sharedPreferences.setString(_accessTokenKey, token);
        
        // Store the user model as a JSON string
        await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
        
        // Update variables in memory
        accessToken = token;
        userModel = model;
        
        // Log the stored data for verification
        _logger.i(accessToken);
        _logger.i(userModel);
    }

    /// Loads the saved user data and access token from local storage into memory.
    static Future getUserData() async {
      // Get SharedPreferences instance
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // Retrieve the access token
      String ? token = sharedPreferences.getString(_accessTokenKey);
      
      // If a token exists, load the user data
      if(token != null){
        accessToken = token;
        
        // Retrieve the user data JSON string
        String ? userData = sharedPreferences.getString(_userModelKey);
        
        // Decode the JSON and map it to the UserModel
        userModel = UserModel.fromJson(jsonDecode(userData!));
      }
      
      // Log the loaded data
      _logger.i(token);
      _logger.i(userModel);
    }

    /// Checks if a user is currently logged in by verifying the presence of an access token.
    static Future<bool> isUserLoggeIn() async {
      // Get SharedPreferences instance
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // Retrieve the access token
      String ? token = sharedPreferences.getString(_accessTokenKey);
      
      // Return true if a token exists, otherwise false
      return token !=null;
    }

    /// Updates the user data in both memory and local storage.
    static Future<void> updateUserData(UserModel model) async {
      // Get SharedPreferences instance
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // Store the updated user data as a JSON string
      await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
      
      // Update memory
      userModel = model;
    }

    /// Clears all stored user data and resets the state in memory (e.g., during logout).
    static Future<void> cleanUserData() async {
      // Get SharedPreferences instance
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // Clear all data from SharedPreferences
      await sharedPreferences.clear();

      accessToken = null;
      userModel = null;
    }
}