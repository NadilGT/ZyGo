import 'package:dio/dio.dart';

class DioClient {
  static final dio = Dio(
    BaseOptions(
      baseUrl: "http://10.72.25.75:3000",
      headers: {"Content-Type":"application/json"}
    )
  );
}