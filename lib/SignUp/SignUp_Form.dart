import 'package:chitchat/AuthBloc/AuthBloc.dart';
import 'package:chitchat/AuthBloc/AuthEvent.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:chitchat/SignUp/Bloc/Bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../consts.dart';

class SignUpForm extends StatefulWidget {
  final UserRepo _userRepo;

  SignUpForm({@required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SignUpBloc _signUpBloc;
  UserRepo get _userRepo => widget._userRepo;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = SignUpBloc(userRepo: _userRepo);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  void _onEmailChanged() {
    _signUpBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _signUpBloc.dispatch(SignUpWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
        bloc: _signUpBloc,
        listener: (BuildContext context, SignUpState state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign Up failed',
                      ),
                      Icon(Icons.error)
                    ],
                  ),
                ),
              );
          }
          if (state.isSubmitting) {
            print("isSubmitting");
            Scaffold.of(context)
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sign up...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            print("isSuccess");
            BlocProvider.of<AuthBloc>(context).dispatch(LoggedIn());
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder(
            bloc: _signUpBloc,
            builder: (BuildContext context, SignUpState state) {
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
                        child: GestureDetector(
                          onTap: isSignUpButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                          child: Container(
                            width: size.width * 0.8,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                                color: isSignUpButtonEnabled(state)
                                    ? Colors.white
                                    : Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.05)),
                            child: Center(
                                child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: kScaffoldBackGroundColor),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
