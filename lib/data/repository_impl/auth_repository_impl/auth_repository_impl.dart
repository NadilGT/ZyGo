import 'package:dio/dio.dart';
import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/login_response_model/login_response_model.dart';
import 'package:zygo/data/models/login_user_model/login_user_model.dart';
import 'package:zygo/domain/repositories/auth_repository/auth_repository.dart';

import '../../../domain/service/api_service.dart';
import '../../../service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService = sl<ApiService>();

  @override
  Future<DataState<LoginResponseModel>> login(LoginUserModel loginUserModel) async {
    try {
      final httpResponse = await _apiService.login(loginUserModel);

      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          httpResponse.response.statusMessage ?? 'Unknown error occurred',
        );
      }
    } on DioException catch (e) {
      return DataFailed(e.message ?? 'Network error occurred');
    } catch (e) {
      return DataFailed('An unexpected error occurred: $e');
    }
  }
}