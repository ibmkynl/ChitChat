import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:chitchat/Repo/userRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:chitchat/ProfileSetPage/Bloc/Bloc.dart';

class ProfileSetBloc extends Bloc<ProfileSetEvents, ProfileSetState> {
  UserRepo _userRepo;
  ProfileSetBloc({@required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo;

  @override
  ProfileSetState get initialState => ProfileSetState.empty();

  @override
  Stream<ProfileSetState> mapEventToState(ProfileSetEvents event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedGenderChanged) {
      yield* _mapInterestedGenderChangedToState(event.interestedGender);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _userRepo.getUser();
      yield* _mapSetUpProfileChangedToState(
          photo: event.photo,
          name: event.name,
          userId: uid,
          gender: event.gender,
          age: event.age,
          location: event.location,
          interestedGender: event.interestedGender);
    }
  }

  Stream<ProfileSetState> _mapPhotoChangedToState(File photo) async* {
    yield currentState.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileSetState> _mapNameChangedToState(String name) async* {
    yield currentState.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileSetState> _mapAgeChangedToState(DateTime age) async* {
    yield currentState.update(
      isAgeEmpty: age == null,
    );
  }

  Stream<ProfileSetState> _mapGenderChangedToState(String gender) async* {
    yield currentState.update(
      isGenderEmpty: gender == null,
    );
  }

  Stream<ProfileSetState> _mapInterestedGenderChangedToState(
      String interestedGender) async* {
    yield currentState.update(
      isInterestedGenderEmpty: interestedGender == null,
    );
  }

  Stream<ProfileSetState> _mapLocationChangedToState(GeoPoint location) async* {
    yield currentState.update(
      isLocationEmpty: location == null,
    );
  }

  Stream<ProfileSetState> _mapSetUpProfileChangedToState({
    String name,
    File photo,
    String userId,
    String gender,
    String interestedGender,
    DateTime age,
    GeoPoint location,
  }) async* {
    yield ProfileSetState.loading();
    try {
      await _userRepo.profileSetUp(
          photo, userId, name, gender, interestedGender, age, location);
      yield ProfileSetState.success();
    } catch (_) {
      yield ProfileSetState.failure();
    }
  }
}
