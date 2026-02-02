import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/pricing_model/pricing_model.dart';
import 'package:zygo/data/models/pricing_params/pricing_params.dart';
import 'package:zygo/domain/repositories/pricing_repository/pricing_repository.dart';
import 'package:zygo/domain/usecases/usecase/usecase.dart';

import '../../../service_locator.dart';

class PricingUseCase implements Usecase<DataState<PriceResponseModel>, PricingParams>{
  @override
  Future<DataState<PriceResponseModel>> call({PricingParams ? params}) {
    return sl<PricingRepository>().getPrice(
      params!.vehicle,
      params.distance,
      params.duration
    );
  }

}