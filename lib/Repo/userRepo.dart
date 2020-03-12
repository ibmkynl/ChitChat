import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';

class UserRepo {
  final FirebaseAuth _firebaseAuth;
  final Firestore _fireStore;

  UserRepo({
    FirebaseAuth firebaseAuth,
    Firestore fireStore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _fireStore = fireStore ?? Firestore.instance;

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });
    return exist;
  }

  Future<void> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<void> profileSetUp(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedGender,
      DateTime age,
      GeoPoint location) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(photo);

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _fireStore.collection('users').document(userId).setData({
          'uid': userId,
          'photourl': url,
          'name': name,
          'age': age,
          'location': location,
          'gender': gender,
          'interestedgender': interestedGender,
        });
      });
    });
  }
}
