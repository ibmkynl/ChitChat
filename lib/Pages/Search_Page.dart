import 'package:chitchat/Models/User.dart';
import 'package:chitchat/Repo/searchRepo.dart';
import 'package:chitchat/SearchBloc/Bloc.dart';
import 'package:chitchat/Widgets/Icon_Widget.dart';
import 'package:chitchat/Widgets/Profile_Widget.dart';
import 'package:chitchat/Widgets/UserGender_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatefulWidget {
  final String userId;

  SearchPage({
    this.userId,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchRepo _searchRepo = SearchRepo();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;
  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator().getLastKnownPosition();

    double location = await Geolocator().distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepo: _searchRepo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder(
        bloc: _searchBloc,
        builder: (BuildContext context, SearchState state) {
          print(state);
          if (state is InitialState) {
            _searchBloc.dispatch(LoadUserEvent(userId: widget.userId));
            // fancy loading gif..
            return Center(child: Image.asset('assets/world_gif.webp'));
          }
          if (state is LoadingState) {
            //fancy loading gif..
            return Center(child: Image.asset('assets/world_gif.webp'));
          }
          if (state is LoadUserState) {
            _user = state.user;
            _currentUser = state.currentUser;
            getDifference(_user.location);
            return profileWidget(
                padding: size.height * 0.035,
                photoHeight: size.height * 0.824,
                photoWidth: size.width * 0.95,
                photo: _user.photo,
                clipRadius: size.height * 0.02,
                containerHeight: size.height * 0.3,
                containerWidth: size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      Row(
                        children: <Widget>[
                          userGender(_user.gender),
                          Expanded(
                            child: Text(
                              " " +
                                  _user.name +
                                  ", " +
                                  (DateTime.now().year -
                                          _user.age.toDate().year)
                                      .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.05),
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
                                ? (difference / 1000).floor().toString() +
                                    " km away"
                                : "away",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          iconWidget(EvaIcons.flash, () {}, size.height * 0.04,
                              Colors.yellow),
                          iconWidget(Icons.clear, () {
                            _searchBloc.dispatch(
                                PassUserEvent(widget.userId, _user.uid));
                          }, size.height * 0.08, Colors.blue),
                          iconWidget(FontAwesomeIcons.solidHeart, () {
                            _searchBloc.dispatch(SelectUserEvent(
                                name: _currentUser.name,
                                photoUrl: _currentUser.photo,
                                currentUserId: widget.userId,
                                selectedUserId: _user.uid));
                          }, size.height * 0.06, Colors.red),
                          iconWidget(EvaIcons.options2, () {},
                              size.height * 0.04, Colors.white),
                        ],
                      )
                    ],
                  ),
                ));
          } else {
            return Container();
          }
        });
  }
}
