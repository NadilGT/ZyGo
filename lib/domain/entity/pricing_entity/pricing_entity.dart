import 'package:equatable/equatable.dart';

class PriceResponseEntity extends Equatable {
  final String vehicleType;
  final double baseFare;
  final double distanceCost;
  final double durationCost;
  final double totalFare;
  final String currency;

  const PriceResponseEntity({
    required this.vehicleType,
    required this.baseFare,
    required this.distanceCost,
    required this.durationCost,
    required this.totalFare,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        vehicleType,
        baseFare,
        distanceCost,
        durationCost,
        totalFare,
        currency,
      ];
}