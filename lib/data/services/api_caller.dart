import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import '../models/api_response.dart';

class ApiCaller {
  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String URL, String? token}) async {
    try {
      _logRequest(URL);
      Uri uri = Uri.parse(URL);
      Response response = await get(uri, headers: {
        'token': token ?? ''
      });

      _logger.i(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(
            responseCode: 200,
            responseData: jsonDecode(response.body),
            isSuccess: true);
      } else {
        return ApiResponse(
            responseCode: response.statusCode,
            responseData: jsonDecode(response.body),
            isSuccess: false);
      }
    } catch (e) {
      return ApiResponse(
          responseCode: -1,
          responseData: null,
          isSuccess: false,
          errorMessage: e.toString());
    }
  }

  static Future<ApiResponse> PostRequest(
      {required String URL, Map<String, dynamic>? body, String? token}) async {
    try {
      _logRequest(URL, body: body);
      Uri uri = Uri.parse(URL);
      Response response = await post(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'token': token ?? ''
        },
        body: body != null ? jsonEncode(body) : null,
      );

      _logger.i(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
            responseCode: response.statusCode,
            responseData: jsonDecode(response.body),
            isSuccess: true);
      } else {
        return ApiResponse(
            responseCode: response.statusCode,
            responseData: jsonDecode(response.body),
            isSuccess: false);
      }
    } catch (e) {
      return ApiResponse(
          responseCode: -1,
          responseData: null,
          isSuccess: false,
          errorMessage: e.toString());
    }
  }

  static void _logRequest(String URL, {Map<String, dynamic>? body}) {
    _logger.i('URL =>$URL \n'
        'Body=> $body\n');
  }
}