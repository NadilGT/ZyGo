import 'package:dio/dio.dart';
import 'package:zygo/core/storage/shared_pref_manager.dart';

class TokenInterceptor extends Interceptor {
  final SharedPrefManager sharedPrefManager;

  TokenInterceptor({required this.sharedPrefManager});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await sharedPrefManager.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 unauthorized errors if needed
    if (err.response?.statusCode == 401) {
      // Token expired or invalid - handle logout or refresh
    }
    handler.next(err);
  }
}
