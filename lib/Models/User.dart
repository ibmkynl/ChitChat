import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String gender;
  String interestedGender;
  String photo;
  Timestamp age;
  GeoPoint location;

  User({
    this.uid,
    this.name,
    this.interestedGender,
    this.gender,
    this.location,
    this.photo,
    this.age,
  });
}
