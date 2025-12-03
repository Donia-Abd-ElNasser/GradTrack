part of 'auth_cubit.dart';


abstract class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthSuccess extends AuthState {
final UserModel userModel;

  AuthSuccess({required this.userModel});

}
final class AuthLoading extends AuthState {

}
final class AuthFailure extends AuthState {
  final String errmssg;

  AuthFailure({required this.errmssg});
}