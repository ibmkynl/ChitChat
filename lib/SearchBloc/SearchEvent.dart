import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]) : super();
}

class LoadUserEvent extends SearchEvent {
  final String userId;

  LoadUserEvent({this.userId});
  @override
  List<Object> get props => [userId];
}

class SelectUserEvent extends SearchEvent {
  final String currentUserId, selectedUserId, name, photoUrl;

  SelectUserEvent(
      {this.currentUserId, this.selectedUserId, this.name, this.photoUrl});

  @override
  List<Object> get props => [currentUserId, selectedUserId, name, photoUrl];
}

class PassUserEvent extends SearchEvent {
  final String currentUserId, selectedUserId;

  PassUserEvent(this.currentUserId, this.selectedUserId);

  @override
  List<Object> get props => [currentUserId, selectedUserId];
}
