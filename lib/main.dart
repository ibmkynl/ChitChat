import 'package:chitchat/AuthBloc/Bloc.dart';
import 'package:chitchat/Block_delegate.dart';
import 'package:chitchat/Login/Login_Page.dart';
import 'package:chitchat/ProfileSetPage/Profile_page.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:chitchat/pages/Page_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'SplashScreen.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepo _userRepo = UserRepo();
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = AuthBloc(userRepo: _userRepo);
    _authBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder(
          bloc: _authBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Uninitialized) {
              return SplashPage();
            }
            if (state is Authenticated) {
              return PageChanger(
                userId: state.userId,
              );
            }
            if (state is AuthButNotSet) {
              return ProfilePage(
                userId: state.userId,
                userRepo: _userRepo,
              );
            }
            if (state is Unauthenticated) {
              return LoginPage(userRepo: _userRepo);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
