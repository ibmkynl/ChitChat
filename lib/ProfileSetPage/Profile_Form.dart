import 'dart:io';

import 'package:chitchat/AuthBloc/Bloc.dart';
import 'package:chitchat/ProfileSetPage/Bloc/ProfileSetBloc.dart';
import 'package:chitchat/ProfileSetPage/Bloc/ProfileSetEvents.dart';
import 'package:chitchat/ProfileSetPage/Bloc/ProfileSetState.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:chitchat/Widgets/Gender_Widget.dart';
import 'package:chitchat/Widgets/TextField_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../consts.dart';

class ProfileForm extends StatefulWidget {
  final UserRepo _userRepo;

  ProfileForm({@required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  DateTime age;
  GeoPoint location;
  File photo;
  String gender, interestedGender;
  final TextEditingController _nameController = TextEditingController();
  ProfileSetBloc _profileSetBloc;
  UserRepo get _userRepo => widget._userRepo;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      gender != null &&
      interestedGender != null &&
      photo != null &&
      age != null;

  bool isButtonEnable(ProfileSetState state) {
    return isFilled && !state.isSubmitting;
  }

  _onSubmitted() async {
    await _getLocation();
    _profileSetBloc.dispatch(Submitted(
        name: _nameController.text,
        age: age,
        location: location,
        gender: gender,
        interestedGender: interestedGender,
        photo: photo));
  }

  _getLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    location = GeoPoint(position.latitude, position.longitude);
  }

  @override
  void initState() {
    _getLocation();
    _profileSetBloc = ProfileSetBloc(userRepo: _userRepo);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _profileSetBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
        bloc: _profileSetBloc,
        listener: (BuildContext context, ProfileSetState state) {
          if (state.isFailure) {
            print("Failed");
            Scaffold.of(context)
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile creation failed',
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
                      Text('Creating...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            print("isSuccess");
            BlocProvider.of<AuthBloc>(context).dispatch(LoggedIn());
          }
        },
        child: BlocBuilder(
            bloc: _profileSetBloc,
            builder: (BuildContext context, ProfileSetState state) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: kScaffoldBackGroundColor,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: size.width,
                        child: CircleAvatar(
                          radius: size.width * 0.3,
                          backgroundColor: Colors.transparent,
                          child: photo == null
                              ? GestureDetector(
                                  onTap: () async {
                                    File getPick = await FilePicker.getFile(
                                        type: FileType.IMAGE);

                                    if (getPick != null) {
                                      setState(() {
                                        photo = getPick;
                                      });
                                    }
                                  },
                                  child: Image.asset('assets/profilephoto.png'))
                              : GestureDetector(
                                  onTap: () async {
                                    File getPick = await FilePicker.getFile(
                                        type: FileType.IMAGE);

                                    if (getPick != null) {
                                      setState(() {
                                        photo = getPick;
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: size.width * 0.3,
                                    backgroundImage: FileImage(photo),
                                  ),
                                ),
                        ),
                      ),
                      textFieldWidget(_nameController, "Name", size),
                      GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1920, 1, 1),
                                maxTime:
                                    DateTime(DateTime.now().year - 18, 1, 1),
                                onConfirm: (date) {
                              setState(() {
                                age = date;
                              });
                              print(age);
                              print(_nameController.text);
                              print(gender);
                              print(interestedGender);
                              print(photo);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Text(
                            'Select your birthday',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.09),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.02),
                            child: Text(
                              "You are",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.09),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              genderWidget(
                                  FontAwesomeIcons.venus, "Male", size, gender,
                                  () {
                                setState(() {
                                  gender = "Male";
                                });
                              }),
                              genderWidget(
                                  FontAwesomeIcons.mars, "Female", size, gender,
                                  () {
                                setState(() {
                                  gender = "Female";
                                });
                              }),
                              genderWidget(FontAwesomeIcons.transgender,
                                  "Transgender", size, gender, () {
                                setState(() {
                                  gender = "Transgender";
                                });
                              }),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.02),
                            child: Text(
                              "Looking for",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.09),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              genderWidget(FontAwesomeIcons.venus, "Male", size,
                                  interestedGender, () {
                                setState(() {
                                  interestedGender = "Male";
                                });
                              }),
                              genderWidget(FontAwesomeIcons.mars, "Female",
                                  size, interestedGender, () {
                                setState(() {
                                  interestedGender = "Female";
                                });
                              }),
                              genderWidget(FontAwesomeIcons.transgender,
                                  "Transgender", size, interestedGender, () {
                                setState(() {
                                  interestedGender = "Transgender";
                                });
                              }),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            if (isButtonEnable(state)) {
                              _onSubmitted();
                            } else {}
                          },
                          child: Container(
                            width: size.width * 0.8,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                                color: isButtonEnable(state)
                                    ? Colors.white
                                    : Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.05)),
                            child: Center(
                                child: Text(
                              "Save",
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
}
