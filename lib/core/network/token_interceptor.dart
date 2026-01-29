import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final success = await TokenStorage.refreshToken();

      if (success) {
        final newToken = await TokenStorage.getToken();

        final request = err.requestOptions;

        request.headers['Authorization'] = 'Bearer $newToken';

        final response = await dio.fetch(request);

        return handler.resolve(response);
      }
    }

    handler.next(err);
  }
}
