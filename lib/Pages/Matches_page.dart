import 'package:chitchat/MatchBloc/MatchBloc.dart';
import 'package:chitchat/MatchBloc/MatchEvent.dart';
import 'package:chitchat/MatchBloc/MatchState.dart';
import 'package:chitchat/Models/User.dart';
import 'package:chitchat/Pages/Messaging_Page.dart';
import 'package:chitchat/Repo/matchRepo.dart';
import 'package:chitchat/Widgets/Icon_Widget.dart';
import 'package:chitchat/Widgets/Profile_Widget.dart';
import 'package:chitchat/Widgets/UserGender_Widget.dart';
import 'package:chitchat/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MatchesPage extends StatefulWidget {
  final String userId;

  MatchesPage({
    this.userId,
  });

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  MatchRepo matchRepo = new MatchRepo();
  MatchBloc _matchBloc;

  int difference;
  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator().getLastKnownPosition();

    double location = await Geolocator().distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _matchBloc = new MatchBloc(matchRepo: matchRepo);
    super.initState();
  }

  @override
  void dispose() {
    _matchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder(
        bloc: _matchBloc,
        builder: (BuildContext context, MatchState state) {
          if (state is LoadingState) {
            _matchBloc.dispatch(LoadListsEvent(userId: widget.userId));
            //fancy loading gif.
            return CircularProgressIndicator();
          }
          if (state is LoadUserState) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  title: Text(
                    "Matched users",
                    style: TextStyle(color: Colors.red),
                  ),
                  backgroundColor: Colors.white,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: state.matchedList,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      }
                      if (snapshot.data.documents != null) {
                        final user = snapshot.data.documents;

                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  User selectedUser = await matchRepo
                                      .getUserDetails(user[index].documentID);
                                  User currentUser = await matchRepo
                                      .getUserDetails(widget.userId);

                                  await getDifference(selectedUser.location);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: profileWidget(
                                              padding: size.height * 0.01,
                                              photo: selectedUser.photo,
                                              photoHeight: size.height,
                                              photoWidth: size.width,
                                              clipRadius: size.height * 0.01,
                                              containerWidth: size.width,
                                              containerHeight:
                                                  size.height * 0.2,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.height * 0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        userGender(selectedUser
                                                            .gender),
                                                        Expanded(
                                                          child: Text(
                                                            " " +
                                                                selectedUser
                                                                    .name +
                                                                ", " +
                                                                (DateTime.now()
                                                                            .year -
                                                                        selectedUser
                                                                            .age
                                                                            .toDate()
                                                                            .year)
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    size.height *
                                                                        0.05),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          difference != null
                                                              ? (difference /
                                                                          1000)
                                                                      .floor()
                                                                      .toString() +
                                                                  " km away"
                                                              : "away",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  size.height *
                                                                      0.02),
                                                          child: iconWidget(
                                                              Icons.message,
                                                              () {
                                                            _matchBloc.dispatch(
                                                                OpenChatEvent(
                                                                    currentUser:
                                                                        widget
                                                                            .userId,
                                                                    selectedUser:
                                                                        selectedUser
                                                                            .uid));
                                                            pageScroll(
                                                                MessagingPage(
                                                                  currentUser:
                                                                      currentUser,
                                                                  selectedUser:
                                                                      selectedUser,
                                                                ),
                                                                context);
                                                          }, size.height * 0.04,
                                                              Colors.white),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                },
                                child: profileWidget(
                                    padding: size.height * 0.01,
                                    photo: user[index].data['photourl'],
                                    photoHeight: size.height * 0.3,
                                    photoWidth: size.width * 0.5,
                                    clipRadius: size.height * 0.01,
                                    containerWidth: size.width * 0.5,
                                    containerHeight: size.height * 0.03,
                                    child: Text(
                                      "  " + user[index].data['name'],
                                      style: TextStyle(color: Colors.white),
                                    )),
                              );
                            },
                            childCount: user.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      }
                    }),
                SliverAppBar(
                  pinned: true,
                  title: Text(
                    "Peope choose you",
                    style: TextStyle(color: Colors.red),
                  ),
                  backgroundColor: Colors.white,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: state.selectedList,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      }
                      if (snapshot.data.documents != null) {
                        final user = snapshot.data.documents;
                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  User selectedUser = await matchRepo
                                      .getUserDetails(user[index].documentID);
                                  User currentUser = await matchRepo
                                      .getUserDetails(widget.userId);

                                  await getDifference(selectedUser.location);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: profileWidget(
                                              padding: size.height * 0.01,
                                              photo: selectedUser.photo,
                                              photoHeight: size.height,
                                              photoWidth: size.width,
                                              clipRadius: size.height * 0.01,
                                              containerWidth: size.width,
                                              containerHeight:
                                                  size.height * 0.2,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.height * 0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        userGender(selectedUser
                                                            .gender),
                                                        Expanded(
                                                          child: Text(
                                                            " " +
                                                                selectedUser
                                                                    .name +
                                                                ", " +
                                                                (DateTime.now()
                                                                            .year -
                                                                        selectedUser
                                                                            .age
                                                                            .toDate()
                                                                            .year)
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    size.height *
                                                                        0.05),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          difference != null
                                                              ? (difference /
                                                                          1000)
                                                                      .floor()
                                                                      .toString() +
                                                                  " km away"
                                                              : "away",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        iconWidget(Icons.clear,
                                                            () {
                                                          _matchBloc.dispatch(
                                                              DeleteUserEvent(
                                                                  currentUser:
                                                                      currentUser
                                                                          .uid,
                                                                  selectedUser:
                                                                      selectedUser
                                                                          .uid));
                                                        }, size.height * 0.08,
                                                            Colors.blue),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                        ),
                                                        iconWidget(
                                                            FontAwesomeIcons
                                                                .solidHeart,
                                                            () {
                                                          _matchBloc.dispatch(AcceptUserEvent(
                                                              selectedUser:
                                                                  selectedUser
                                                                      .uid,
                                                              currentUser:
                                                                  currentUser
                                                                      .uid,
                                                              currentUserPhotoUrl:
                                                                  currentUser
                                                                      .photo,
                                                              currentUserName:
                                                                  currentUser
                                                                      .name,
                                                              selectedUserPhotoUrl:
                                                                  selectedUser
                                                                      .photo,
                                                              selectedUserName:
                                                                  selectedUser
                                                                      .name));
                                                        }, size.height * 0.06,
                                                            Colors.red),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                },
                                child: profileWidget(
                                    padding: size.height * 0.01,
                                    photo: user[index].data['photourl'],
                                    photoHeight: size.height * 0.3,
                                    photoWidth: size.width * 0.5,
                                    clipRadius: size.height * 0.01,
                                    containerWidth: size.width * 0.5,
                                    containerHeight: size.height * 0.03,
                                    child: Text(
                                      "  " + user[index].data['name'],
                                      style: TextStyle(color: Colors.white),
                                    )),
                              );
                            },
                            childCount: user.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      }
                    }),
              ],
            );
          }
          return Container();
        });
  }
}
