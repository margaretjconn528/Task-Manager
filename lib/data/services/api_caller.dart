import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/Controller/auth_controller.dart';
import '../models/api_response.dart';

class ApiCaller{
    // logger instance তৈরি করা হয়েছে (debug/log দেখার জন্য)
    static final Logger _logger = Logger();

    // GET request করার method
    static Future<ApiResponse> getRequest({required String URL}) async {
        try{
            // request log করা হচ্ছে
            _logRequest(URL);
            
            // URL কে Uri তে convert করা হচ্ছে
            Uri uri = Uri.parse(URL);
            
            // GET request পাঠানো হচ্ছে (token header সহ)
            Response response = await get(uri,headers: {
                'token' : AuthController.accessToken ?? '' // token না থাকলে empty string
            });

            // response body log করা হচ্ছে
            _logger.i(response.body);

            // যদি response সফল হয় (status 200)
            if(response.statusCode == 200){
                return ApiResponse(
                  responseCode: 200,
                  responseData: jsonDecode(response.body), // json decode করা হচ্ছে
                  isSuccess: true
                );
            }else{
                // অন্য status code হলেও response return করা হচ্ছে (⚠️ এখানে isSuccess true দেওয়া আছে)
                return ApiResponse(
                  responseCode: response.statusCode,
                  responseData: jsonDecode(response.body),
                  isSuccess: true
                );
            }

        }catch(e){
            // যদি error হয়
            return ApiResponse(
                responseCode: -1, // custom error code
                responseData: null,
                isSuccess: false,
                errorMessage: e.toString() // error message
            );
        }
    }

    // POST request করার method
    static Future<ApiResponse> PostRequest({required String URL, Map<String,dynamic>? body}) async {
        try{
            // request log করা হচ্ছে (body সহ)
            _logRequest(URL,body: body);
            
            // URL কে Uri তে convert করা হচ্ছে
            Uri uri = Uri.parse(URL);
            
            // POST request পাঠানো হচ্ছে
            Response response = await post(
              uri,
              headers: {
                "Accept": "application/json", // json accept করবে
                "Content-Type": "application/json", // body json format
                'token' : AuthController.accessToken ?? '' // token header
              },
              // body থাকলে json encode করে পাঠানো হচ্ছে
              body: body != null ? jsonEncode(body) : null,
            );

            // response log করা হচ্ছে
            _logger.i(response.body);

            // যদি success status (200 বা 201)
            if(response.statusCode == 200 || response.statusCode == 201){
                return ApiResponse(
                  responseCode: response.statusCode,
                  responseData: jsonDecode(response.body),
                  isSuccess: true
                );
            }else{
                // যদি error status হয়
                return ApiResponse(
                  responseCode: response.statusCode,
                  responseData: jsonDecode(response.body),
                  isSuccess: false
                );
            }

        }catch(e){
            // exception হলে
            return ApiResponse(
                responseCode: -1,
                responseData: null,
                isSuccess: false,
                errorMessage: e.toString()
            );
        }
    }

    // request log করার private method
    static void _logRequest(String URL,{Map<String,dynamic>? body}){
        _logger.i(
            'URL =>$URL \n' // request URL
            'Body=> $body\n' // request body (nullable)
        );
    }
}