import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class AuthController{
    // access token সংরক্ষণের জন্য key
    static String _accessTokenKey = 'token';
    
    // user model সংরক্ষণের জন্য key
    static String _userModelKey = 'user-data';
    
    // logger instance তৈরি করা হয়েছে (debug/log দেখার জন্য)
    static final Logger _logger = Logger();

    // access token রাখার জন্য variable (nullable)
    static String ? accessToken;
    
    // user model রাখার জন্য variable (nullable)
    static UserModel ? userModel;

    // user data এবং token save করার method
    static Future saveUserData(UserModel model,String token) async {
        // shared preferences instance নেওয়া হচ্ছে
        SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
        
        // token save করা হচ্ছে
        await sharedPreferences.setString(_accessTokenKey, token);
        
        // user model কে json করে save করা হচ্ছে
        await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
        
        // memory তে token assign করা হচ্ছে
        accessToken = token;
        
        // memory তে user model assign করা হচ্ছে
        userModel = model;
        
        // token log করা হচ্ছে
        _logger.i(accessToken);
        
        // user model log করা হচ্ছে
        _logger.i(userModel);
    }

    // saved user data load করার method
    static Future getUserData() async {
      // shared preferences instance নেওয়া হচ্ছে
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // token নেওয়া হচ্ছে
      String ? token = sharedPreferences.getString(_accessTokenKey);
      
      // যদি token থাকে
      if(token != null){
        // memory তে token assign করা হচ্ছে
        accessToken = token;
        
        // user data json নেওয়া হচ্ছে
        String ? userData = sharedPreferences.getString(_userModelKey);
        
        // json decode করে user model বানানো হচ্ছে
        userModel = UserModel.fromJson(jsonDecode(userData!));
      }
      
      // token log করা হচ্ছে
      _logger.i(token);
      
      // user model log করা হচ্ছে
      _logger.i(userModel);
    }

    // user login আছে কিনা check করার method
    static Future<bool> isUserLoggeIn() async {
      // shared preferences instance নেওয়া হচ্ছে
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // token নেওয়া হচ্ছে
      String ? token = sharedPreferences.getString(_accessTokenKey);
      
      // token থাকলে true return করবে, না থাকলে false
      return token !=null;
    }

    // user data update করার method
    static Future<void> updateUserData(UserModel model) async {
      // shared preferences instance নেওয়া হচ্ছে
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // নতুন user data json করে save করা হচ্ছে
      await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
      
      userModel = model;
    }

    // সব user data clear করার method (logout এর জন্য)
    static Future<void> cleanUserData() async {
      // shared preferences instance নেওয়া হচ্ছে
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      
      // সব data delete করা হচ্ছে
      await sharedPreferences.clear();

      accessToken = null;
      userModel = null;
    }
}