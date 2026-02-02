abstract class PricingState {}

class PricingInitial extends PricingState{}

class PricingInLoading extends PricingState{}

class PricingSuccess extends PricingState{
  final dynamic data;
  PricingSuccess({this.data});
}

class PricingFailure extends PricingState{
  final String error;
  PricingFailure(this.error);
}