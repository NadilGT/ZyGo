import 'package:dio/dio.dart';
import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/profile_response_model/profile_response_model.dart';
import 'package:zygo/domain/repositories/profile_repository/profile_repository.dart';
import 'package:zygo/domain/service/api_service.dart';
import 'package:zygo/service_locator.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final ApiService _apiService = sl<ApiService>();

  @override
  Future<DataState<ProfileResponseModel>> profile() async {
    try{
      final httpResponse = await _apiService.profile();

      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          httpResponse.response.statusMessage ?? "Unknown error occurred"
        );
      }
    } on DioException catch (e) {
      return DataFailed(e.message ?? "Network error occurred");
    } catch (e) {
      return DataFailed('An unexpected error occurred: $e');
    }
  }
}