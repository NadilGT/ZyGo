import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/login_response_model/login_response_model.dart';
import 'package:zygo/data/models/login_user_model/login_user_model.dart';

abstract class AuthRepository {
  Future<DataState<LoginResponseModel>> login(LoginUserModel loginUserModel);
}