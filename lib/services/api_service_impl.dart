import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:git_auth/services/api_service.dart';

import '../utils/dio_error_handler.dart';
import 'api_interceptor.dart';

class ApiServiceImpl implements ApiService{
  final Dio dio;

  ApiServiceImpl() : dio = Dio() {
    // Add the custom interceptor during initialization
    dio.interceptors.add(ApiInterceptor());
  }

  @override
  Future<Response?> getOrganization() async {
    try {
      // Make a POST request to send the OTP
      final response = await dio.get(
        'https://api.github.com/user/orgs'
      );
      // Return the response if successful
      return response;
    } on DioException catch (dioError) {
      // Handle DioException (network errors, timeouts, etc.)
      final errorMessage = DioErrorHandler.handleDioError(dioError);
      log('Error: $errorMessage'); // Log the error message for debugging
      return dioError.response; // Return the response if available
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected Error: $e'); // Log unexpected errors for debugging
      return null; // Return null if an unexpected error occurs
    }
  }

}