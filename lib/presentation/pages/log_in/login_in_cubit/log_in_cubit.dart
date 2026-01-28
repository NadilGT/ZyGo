import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/core/storage/shared_pref_manager.dart';
import 'package:zygo/data/models/login_user_model/login_user_model.dart';
import 'package:zygo/domain/usecases/login_usecase/login_use_case.dart';
import 'package:zygo/presentation/pages/log_in/login_in_cubit/log_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zygo/service_locator.dart';

class LogInCubit extends Cubit<LogInState>{
  LogInCubit(): super(LogInInitial());

  Future<void> logIn(LoginUserModel loginUserModel)async{
    emit(LogInLoading());

    final result = await sl<LoginUseCase>().call(
      params: loginUserModel
    );

    if (result is DataSuccess){
      // Save the token for authenticated requests
      await sl<SharedPrefManager>().saveToken(result.data!.token);
      emit(LogInSuccess(data: result));
    } else if (result is DataFailed){
      emit(LogInFailure(result.error ?? "Sign In Failed"));
    }
  }

}