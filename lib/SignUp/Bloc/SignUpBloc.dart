import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:chitchat/SignUp/Bloc/Bloc.dart';
import 'package:meta/meta.dart';
import '../../Validators.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  UserRepo _userRepo;

  SignUpBloc({@required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo;

  @override
  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<SignUpState> transform(
    Stream<SignUpEvent> events,
    Stream<SignUpState> Function(SignUpEvent event) next,
  ) {
    final observableStream = events as Observable<SignUpEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounce(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SignUpState.loading();
    try {
      print("Should be");
      await _userRepo.signUpWithEmail(email, password);
      yield SignUpState.success();
    } catch (e) {
      print(e.toString());
      yield SignUpState.failure();
    }
  }
}
