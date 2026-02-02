import 'package:dio/dio.dart';
import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/pricing_model/pricing_model.dart';
import 'package:zygo/domain/repositories/pricing_repository/pricing_repository.dart';
import 'package:zygo/domain/service/api_service.dart';
import 'package:zygo/service_locator.dart';

class PricingRepositoryImpl implements PricingRepository{
  final ApiService _apiService = sl<ApiService>();

  @override
  Future<DataState<PriceResponseModel>> getPrice(String vehicle, String distance, String duration)async{
    try{
      final httpResponse = await _apiService.getPrice(vehicle, distance, duration);

      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(httpResponse.response.statusMessage ?? "Unknown error occurred");
      }
    } on DioException catch (e) {
      return DataFailed(e.message ?? "Network error occurred");
    }
     catch (e) {
      return DataFailed('An unexpected error occurred: $e');
    }
  }
}