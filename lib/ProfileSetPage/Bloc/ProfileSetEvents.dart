import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ProfileSetEvents extends Equatable {
  ProfileSetEvents([List props = const []]) : super();
}

class NameChanged extends ProfileSetEvents {
  final String name;

  NameChanged({@required this.name}) : super([name]);

  @override
  List<Object> get props => [name];
}

class PhotoChanged extends ProfileSetEvents {
  final File photo;

  PhotoChanged({@required this.photo}) : super([photo]);

  @override
  List<Object> get props => [photo];
}

class AgeChanged extends ProfileSetEvents {
  final DateTime age;

  AgeChanged({@required this.age}) : super([age]);

  @override
  List<Object> get props => [age];
}

class GenderChanged extends ProfileSetEvents {
  final String gender;

  GenderChanged({@required this.gender}) : super([gender]);

  @override
  List<Object> get props => [gender];
}

class InterestedGenderChanged extends ProfileSetEvents {
  final String interestedGender;

  InterestedGenderChanged({@required this.interestedGender})
      : super([interestedGender]);

  @override
  List<Object> get props => [interestedGender];
}

class LocationChanged extends ProfileSetEvents {
  final GeoPoint location;

  LocationChanged({@required this.location}) : super([location]);

  @override
  List<Object> get props => [location];
}

class Submitted extends ProfileSetEvents {
  final String name, gender, interestedGender;
  final DateTime age;
  final GeoPoint location;
  final File photo;

  Submitted({
    @required this.photo,
    @required this.name,
    @required this.age,
    @required this.gender,
    @required this.location,
    @required this.interestedGender,
  }) : super([photo, name, age, gender, location, interestedGender]);

  @override
  List<Object> get props =>
      [photo, name, age, gender, location, interestedGender];
}
