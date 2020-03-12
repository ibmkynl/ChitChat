import 'package:chitchat/ProfileSetPage/Bloc/Bloc.dart';
import 'package:chitchat/ProfileSetPage/Profile_Form.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../consts.dart';

class ProfilePage extends StatefulWidget {
  final _userRepo;
  final userId;

  ProfilePage({@required UserRepo userRepo, String userId})
      : assert(userRepo != null && userId != null),
        userId = userId,
        _userRepo = userRepo;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileSetBloc _profileSetBloc;
  UserRepo get _userRepo => widget._userRepo;

  @override
  void initState() {
    _profileSetBloc = ProfileSetBloc(userRepo: _userRepo);
    super.initState();
  }

  @override
  void dispose() {
    _profileSetBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile setup"),
        centerTitle: true,
        backgroundColor: kScaffoldBackGroundColor,
        elevation: 0,
      ),
      body: BlocProvider<ProfileSetBloc>(
        bloc: _profileSetBloc,
        child: ProfileForm(
          userRepo: _userRepo,
        ),
      ),
    );
  }
}
