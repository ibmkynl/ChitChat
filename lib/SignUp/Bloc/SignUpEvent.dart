import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class SignUpEvent extends Equatable {
  SignUpEvent([List props = const []]) : super();
}

class EmailChanged extends SignUpEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SignUpEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  List<Object> get props => [password];
}

class Submitted extends SignUpEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super([email, password]);

  @override
  List<Object> get props => [email, password];
}

class SignUpWithCredentialsPressed extends SignUpEvent {
  final String email;
  final String password;

  SignUpWithCredentialsPressed({@required this.email, @required this.password})
      : super([email, password]);
  @override
  List<Object> get props => [email, password];
}
