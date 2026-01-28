import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/domain/usecases/profile_usecase/profile_usecase.dart';
import 'package:zygo/presentation/pages/Profile/profile_cubit/profile_state.dart';

import '../../../../service_locator.dart';

class ProfileCubit extends Cubit<ProfileState>{
  ProfileCubit(): super(ProfileInitial());

  Future<void> getProfile()async{
    emit(ProfileLoading());

    final result = await sl<ProfileUsecase>().call();

    if (result is DataSuccess){
      emit(ProfileSuccess(result.data!));
    } else if (result is DataFailed){
      emit(ProfileFailure(result.error ?? "Profile Failed"));
    }
  }
}