import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import '../models/api_response.dart';

/// A utility class for making API requests using the http package.
class ApiCaller {
  static final Logger _logger = Logger();

  /// Sends a GET request to the specified [URL].
  ///
  /// Optionally accepts a [token] for authentication.
  /// Returns an [ApiResponse] containing the status and data.
  static Future<ApiResponse> getRequest({required String URL, String? token}) async {
    try {
      _logRequest(URL);
      Uri uri = Uri.parse(URL);
      // Perform the GET request
      Response response = await get(uri, headers: {
        'token': token ?? ''
      });

      _logger.i(response.body);

      // Check if the request was successful (HTTP 200 OK)
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
      // Return an error response if an exception occurs
      return ApiResponse(
          responseCode: -1,
          responseData: null,
          isSuccess: false,
          errorMessage: e.toString());
    }
  }

  /// Sends a POST request to the specified [URL] with an optional [body].
  ///
  /// Optionally accepts a [token] for authentication.
  /// The [body] is encoded as a JSON string.
  /// Returns an [ApiResponse] containing the status and data.
  static Future<ApiResponse> PostRequest(
      {required String URL, Map<String, dynamic>? body, String? token}) async {
    try {
      _logRequest(URL, body: body);
      Uri uri = Uri.parse(URL);
      // Perform the POST request
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

      // Check for successful status codes (200 OK or 201 Created)
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

  /// Logs the details of an API request.
  static void _logRequest(String URL, {Map<String, dynamic>? body}) {
    _logger.i('URL =>$URL \n'
        'Body=> $body\n');
  }
}