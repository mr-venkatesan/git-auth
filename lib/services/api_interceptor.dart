import 'package:dio/dio.dart';
import 'package:git_auth/utils/app_secure_storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Fetch the access token from local storage asynchronously
    String? token = await AppSecureStorage.getAccessToken();

    // Create the Authorization header value
    String auth = 'Bearer $token';

    // Modify the request before it is sent by adding the Authorization header
    options.headers['Authorization'] = auth;

    options.headers['Accept'] = "application/vnd.github+json";

    options.headers['X-GitHub-Api-Version'] = "2022-11-28";

    // Continue with the modified request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Continue with the response as it is
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Continue with the error as it is
    handler.next(err);
  }
}