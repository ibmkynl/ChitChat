import 'package:equatable/equatable.dart';

abstract class MatchEvent extends Equatable {
  MatchEvent([List props = const []]) : super();
}

class LoadListsEvent extends MatchEvent {
  final String userId;

  LoadListsEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class AcceptUserEvent extends MatchEvent {
  final String currentUser,
      selectedUser,
      selectedUserName,
      selectedUserPhotoUrl,
      currentUserName,
      currentUserPhotoUrl;

  AcceptUserEvent(
      {this.currentUser,
      this.selectedUser,
      this.currentUserName,
      this.currentUserPhotoUrl,
      this.selectedUserName,
      this.selectedUserPhotoUrl});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
        currentUser,
        currentUserPhotoUrl,
        selectedUserName,
        selectedUserPhotoUrl
      ];
}

class DeleteUserEvent extends MatchEvent {
  final String currentUser, selectedUser;

  DeleteUserEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [currentUser, selectedUser];
}

class OpenChatEvent extends MatchEvent {
  final String currentUser, selectedUser;

  OpenChatEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [currentUser, selectedUser];
}
