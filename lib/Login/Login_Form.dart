import 'package:chitchat/AuthBloc/AuthBloc.dart';
import 'package:chitchat/AuthBloc/AuthEvent.dart';
import 'package:chitchat/Login/Bloc/Bloc.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:chitchat/SignUp/SignUp_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../consts.dart';

class LoginForm extends StatefulWidget {
  final UserRepo _userRepo;

  LoginForm({@required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  UserRepo get _userRepo => widget._userRepo;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = LoginBloc(userRepo: widget._userRepo);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    print("submitted");
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
        bloc: _loginBloc,
        listener: (BuildContext context, LoginState state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Login Failure',
                      ),
                      Icon(Icons.error)
                    ],
                  ),
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logging In...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthBloc>(context).dispatch(LoggedIn());
          }
        },
        child: BlocBuilder(
          bloc: _loginBloc,
          builder: (BuildContext context, LoginState state) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: kScaffoldBackGroundColor,
                width: size.width,
                height: size.height - size.height * 0.105,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "ChitChat",
                        style: TextStyle(
                            fontFamily: 'Coiny',
                            fontSize: size.width * 0.2,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Divider(
                        height: size.height * 0.05,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (_) {
                          return !state.isEmailValid ? 'Invalid Email' : null;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.03),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        autocorrect: false,
                        validator: (_) {
                          return !state.isPasswordValid
                              ? 'Invalid Password'
                              : null;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.03),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                            child: Container(
                              width: size.width * 0.8,
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                  color: isLoginButtonEnabled(state)
                                      ? Colors.white
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(
                                      size.height * 0.05)),
                              child: Center(
                                  child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: size.height * 0.025,
                                    color: kScaffoldBackGroundColor),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return SignUpPage(userRepo: _userRepo);
                                }),
                              );
                            },
                            child: Text(
                              "New here? Create an account",
                              style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
