import 'package:chitchat/Repo/userRepo.dart';
import 'package:chitchat/SignUp/Bloc/SignUpBloc.dart';
import 'package:chitchat/SignUp/SignUp_Form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../consts.dart';

class SignUpPage extends StatefulWidget {
  final UserRepo _userRepo;

  SignUpPage({Key key, @required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo,
        super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignUpBloc _signUpBloc;

  UserRepo get _userRepo => widget._userRepo;

  @override
  void initState() {
    _signUpBloc = SignUpBloc(userRepo: _userRepo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        backgroundColor: kScaffoldBackGroundColor,
        elevation: 0,
      ),
      body: BlocProvider<SignUpBloc>(
        bloc: _signUpBloc,
        child: SignUpForm(
          userRepo: _userRepo,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }
}
