import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:chitchat/Login/Bloc/LoginEvent.dart';
import 'package:chitchat/Login/Bloc/LoginState.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:flutter/cupertino.dart';

import '../../Validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepo _userRepo;

  LoginBloc({@required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transform(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounce(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepo.signInWithEmail(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
