import 'package:chitchat/MatchBloc/MatchEvent.dart';
import 'package:chitchat/MatchBloc/MatchState.dart';

import 'package:bloc/bloc.dart';
import 'package:chitchat/Repo/matchRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchRepo _matchRepo;

  MatchBloc({@required MatchRepo matchRepo})
      : assert(matchRepo != null),
        _matchRepo = matchRepo;

  @override
  MatchState get initialState => LoadingState();

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is LoadListsEvent) {
      yield* _mapLoadListToState(currentUserId: event.userId);
    }
    if (event is DeleteUserEvent) {
      yield* _mapDeleteUserState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
    }
    if (event is AcceptUserEvent) {
      yield* _mapAcceptUserState(
        currentUserId: event.currentUser,
        selectedUserId: event.selectedUser,
        selectedUserName: event.selectedUserName,
        selectedUserPhotoUrl: event.selectedUserPhotoUrl,
        currentUserName: event.currentUserName,
        currentUserPhotoUrl: event.currentUserPhotoUrl,
      );
    }
    if (event is OpenChatEvent) {
      yield* _mapOpenChatState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
    }
  }

  Stream<MatchState> _mapLoadListToState({String currentUserId}) async* {
    yield LoadingState();
    Stream<QuerySnapshot> matchedList =
        _matchRepo.getMatchedList(currentUserId);
    Stream<QuerySnapshot> selectedList =
        _matchRepo.getSelectedList(currentUserId);
    yield LoadUserState(matchedList: matchedList, selectedList: selectedList);
  }

  Stream<MatchState> _mapDeleteUserState(
      {currentUserId, selectedUserId}) async* {
    _matchRepo.deleteUser(currentUserId, selectedUserId);
  }

  Stream<MatchState> _mapOpenChatState({currentUserId, selectedUserId}) async* {
    _matchRepo.openChat(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
  }

  Stream<MatchState> _mapAcceptUserState(
      {currentUserId,
      selectedUserId,
      selectedUserName,
      selectedUserPhotoUrl,
      currentUserName,
      currentUserPhotoUrl}) async* {
    await _matchRepo.selectUser(currentUserId, selectedUserId, selectedUserName,
        selectedUserPhotoUrl, currentUserName, currentUserPhotoUrl);
  }
}
