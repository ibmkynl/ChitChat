import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super();
}

class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  final String userId;

  Authenticated(this.userId) : super([userId]);

  @override
  List<Object> get props => [userId];
}

class AuthButNotSet extends AuthenticationState {
  final String userId;

  AuthButNotSet(this.userId) : super([userId]);

  @override
  List<Object> get props => [userId];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}
