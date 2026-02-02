import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/pricing_params/pricing_params.dart';
import 'package:zygo/domain/usecases/pricing_use_case/pricing_use_case.dart';
import 'package:zygo/presentation/pages/map/pricing_cubit/pricing_state.dart';
import 'package:zygo/service_locator.dart';

class PricingCubit extends Cubit<PricingState> {
  PricingCubit() : super(PricingInitial());

  Future<void> getPrice({
    required String vehicle,
    required String distance,
    required String duration,
  }) async {
    emit(PricingInLoading());

    final result = await sl<PricingUseCase>().call(
      params: PricingParams(
        vehicle: vehicle,
        distance: distance,
        duration: duration,
      ),
    );

    if (result is DataSuccess){
      emit(PricingSuccess(data: result.data));
    } else if (result is DataFailed) {
      emit(PricingFailure(result.error ?? "Failed to calculate price"));
    }
  }
}
