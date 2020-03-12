import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chitchat/AuthBloc/AuthEvent.dart';
import 'package:chitchat/AuthBloc/AuthState.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:meta/meta.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepo _userRepo;

  AuthBloc({@required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepo.isSignedIn();
      if (isSignedIn) {
        final uid = await _userRepo.getUser();
        final isFirstTime = await _userRepo.isFirstTime(uid);
        if (!isFirstTime) {
          yield AuthButNotSet(uid);
        } else {
          yield Authenticated(uid);
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final isFirstTime = await _userRepo.isFirstTime(await _userRepo.getUser());
    if (!isFirstTime) {
      yield AuthButNotSet(await _userRepo.getUser());
    } else {
      yield Authenticated(await _userRepo.getUser());
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepo.signOut();
  }
}
