import 'package:chitchat/Models/User.dart';
import 'package:chitchat/Repo/searchRepo.dart';

import 'dart:async';
import 'Bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepo _searchRepo;
  SearchBloc({
    @required SearchRepo searchRepo,
  })  : assert(
          searchRepo != null,
        ),
        _searchRepo = searchRepo;

  @override
  SearchState get initialState => InitialState();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId,
          name: event.name,
          photoUrl: event.photoUrl);
    }
    if (event is PassUserEvent) {
      yield* _mapPassToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    }
    if (event is LoadUserEvent) {
      yield* _mapLoadUserToState(currentUserId: event.userId);
    }
  }

  Stream<SearchState> _mapLoadUserToState({String currentUserId}) async* {
    yield LoadingState();
    User user = await _searchRepo.getUser(currentUserId);
    User currentUser = await _searchRepo.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapSelectToState(
      {String currentUserId,
      String selectedUserId,
      String name,
      String photoUrl}) async* {
    yield LoadingState();
    User user = await _searchRepo.chooseUser(
        currentUserId, selectedUserId, name, photoUrl);

    User currentUser = await _searchRepo.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapPassToState(
      {String currentUserId, String selectedUserId}) async* {
    yield LoadingState();
    User user = await _searchRepo.passUser(currentUserId, selectedUserId);
    User currentUser = await _searchRepo.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }
}
