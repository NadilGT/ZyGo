import 'package:zygo/core/storage/data_state.dart';
import 'package:zygo/data/models/pricing_model/pricing_model.dart';

abstract class PricingRepository {
  Future<DataState<PriceResponseModel>> getPrice(
    String vehicle,
    String distance,
    String duration
  );
}