import 'package:chitchat/Login/Bloc/Bloc.dart';
import 'package:chitchat/Login/Login_Form.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../consts.dart';

class LoginPage extends StatefulWidget {
  final UserRepo _userRepo;

  LoginPage({Key key, @required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo,
        super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  UserRepo get _userRepo => widget._userRepo;
  @override
  void initState() {
    _loginBloc = LoginBloc(userRepo: widget._userRepo);
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
        backgroundColor: kScaffoldBackGroundColor,
        elevation: 0,
      ),
      body: BlocProvider<LoginBloc>(
        bloc: _loginBloc,
        child: LoginForm(
          userRepo: _userRepo,
        ),
      ),
    );
  }
}
