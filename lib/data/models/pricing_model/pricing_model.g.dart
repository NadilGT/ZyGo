// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceResponseModel _$PriceResponseModelFromJson(Map<String, dynamic> json) =>
    PriceResponseModel(
      vehicleType: json['vehicle_type'] as String,
      baseFare: (json['base_fare'] as num).toDouble(),
      distanceCost: (json['distance_cost'] as num).toDouble(),
      durationCost: (json['duration_cost'] as num).toDouble(),
      totalFare: (json['total_fare'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PriceResponseModelToJson(PriceResponseModel instance) =>
    <String, dynamic>{
      'vehicle_type': instance.vehicleType,
      'base_fare': instance.baseFare,
      'distance_cost': instance.distanceCost,
      'duration_cost': instance.durationCost,
      'total_fare': instance.totalFare,
      'currency': instance.currency,
    };
