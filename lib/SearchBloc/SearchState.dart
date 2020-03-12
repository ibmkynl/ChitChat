import 'package:chitchat/Models/User.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super();
}

class InitialState extends SearchState {
  @override
  List<Object> get props => [];
}

class LoadingState extends SearchState {
  @override
  List<Object> get props => [];
}

class LoadUserState extends SearchState {
  final User user, currentUser;

  LoadUserState(this.user, this.currentUser);

  @override
  List<Object> get props => [user, currentUser];
}
