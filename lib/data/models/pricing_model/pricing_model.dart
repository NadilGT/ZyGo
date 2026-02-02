import 'package:json_annotation/json_annotation.dart';
import 'package:zygo/domain/entity/pricing_entity/pricing_entity.dart';

part 'pricing_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PriceResponseModel extends PriceResponseEntity {
  @JsonKey(name: 'vehicle_type')
  @override
  final String vehicleType;

  @JsonKey(name: 'base_fare')
  @override
  final double baseFare;

  @JsonKey(name: 'distance_cost')
  @override
  final double distanceCost;

  @JsonKey(name: 'duration_cost')
  @override
  final double durationCost;

  @JsonKey(name: 'total_fare')
  @override
  final double totalFare;

  @override
  final String currency;

  const PriceResponseModel({
    required this.vehicleType,
    required this.baseFare,
    required this.distanceCost,
    required this.durationCost,
    required this.totalFare,
    required this.currency,
  }) : super(
          vehicleType: vehicleType,
          baseFare: baseFare,
          distanceCost: distanceCost,
          durationCost: durationCost,
          totalFare: totalFare,
          currency: currency,
        );

  factory PriceResponseModel.fromJson(Map<String, dynamic> json) => _$PriceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceResponseModelToJson(this);
}
