import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/profile_response_model/profile_response_model.dart';

abstract class ProfileRepository {
  Future<DataState<ProfileResponseModel>> profile();
}