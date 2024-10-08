import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again later.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again later.';
      case DioExceptionType.badCertificate:
        return 'Bad certificate. There might be a security issue with the server.';
      case DioExceptionType.badResponse:
        return _handleServerError(error.response);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your network settings.';
      case DioExceptionType.unknown:
        return 'An unknown error occurred. Please try again.';
      default:
        return 'An unexpected error occurred.';
    }
  }

  static String _handleServerError(Response? response) {
    if (response == null) {
      return 'No response from server.';
    }
    switch (response.statusCode) {
      case 400:
        return 'Bad Request: ${response.data}';
      case 401:
        return 'Unauthorized: ${response.data}';
      case 403:
        return 'Forbidden: ${response.data}';
      case 404:
        return 'Not Found: ${response.data}';
      case 500:
        return 'Internal Server Error. Please try again later.';
      default:
        return 'Received invalid status code: ${response.statusCode}';
    }
  }
}
