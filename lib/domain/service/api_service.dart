import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zygo/data/models/login_user_model/login_user_model.dart';
import 'package:zygo/data/models/pricing_model/pricing_model.dart';
import 'package:zygo/data/models/profile_response_model/profile_response_model.dart';

import '../../core/constants/api_constants.dart';
import '../../data/models/login_response_model/login_response_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseURL)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST("/auth/login")
  Future<HttpResponse<LoginResponseModel>> login(
    @Body() LoginUserModel loginUserModel,
  );

  @GET("/auth/profile")
  Future<HttpResponse<ProfileResponseModel>> profile();

  @POST("/auth/pricing")
  Future<HttpResponse<PriceResponseModel>> getPrice(
    @Query("vehicle") String vehicle,
    @Query("distance") String distance,
    @Query("duration") String duration,
  );
}