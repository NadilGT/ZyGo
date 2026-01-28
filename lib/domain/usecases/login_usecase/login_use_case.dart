import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/login_user_model/login_user_model.dart';
import 'package:zygo/domain/usecases/usecase/usecase.dart';
import 'package:zygo/service_locator.dart';

import '../../repositories/auth_repository/auth_repository.dart';

class LoginUseCase implements Usecase<DataState, LoginUserModel>{
  @override
  Future<DataState> call({LoginUserModel ? params}) {
    return sl<AuthRepository>().login(params!);
  }
  
}