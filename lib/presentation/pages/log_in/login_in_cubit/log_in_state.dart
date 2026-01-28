abstract class LogInState {}

class LogInInitial extends LogInState{}

class LogInLoading extends LogInState{}

class LogInSuccess extends LogInState{
  final dynamic data;
  LogInSuccess({this.data});
}

class LogInFailure extends LogInState{
  final String error;
  LogInFailure(this.error);
}
