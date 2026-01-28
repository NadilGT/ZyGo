import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/profile_response_model/profile_response_model.dart';
import 'package:zygo/domain/repositories/profile_repository/profile_repository.dart';
import 'package:zygo/domain/usecases/usecase/usecase.dart';
import 'package:zygo/service_locator.dart';

class ProfileUsecase implements Usecase<DataState<ProfileResponseModel>, void>{
  @override
  Future<DataState<ProfileResponseModel>> call({void params}) {
    return sl<ProfileRepository>().profile();
  }
  
}