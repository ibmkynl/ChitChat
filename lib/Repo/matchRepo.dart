import 'package:chitchat/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchRepo {
  final Firestore _fireStore;

  MatchRepo({
    Firestore fireStore,
  }) : _fireStore = fireStore ?? Firestore.instance;

  Stream<QuerySnapshot> getMatchedList(userId) {
    return _fireStore
        .collection('users')
        .document(userId)
        .collection('matchedlist')
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedList(userId) {
    return _fireStore
        .collection('users')
        .document(userId)
        .collection('selectedlist')
        .snapshots();
  }

  Future<User> getUserDetails(userId) async {
    User _user = new User();

    await _fireStore.collection('users').document(userId).get().then((user) {
      _user.uid = user.documentID;
      _user.name = user['name'];
      _user.photo = user['photourl'];
      _user.age = user['age'];
      _user.location = user['location'];
      _user.gender = user['gender'];
      _user.interestedGender = user['interestedgender'];
    });

    return _user;
  }

  Future openChat({currentUserId, selectedUserId}) async {
    await _fireStore
        .collection('users')
        .document(currentUserId)
        .collection('chats')
        .document(selectedUserId)
        .setData({
      'timestamp': DateTime.now(),
    });
    await _fireStore
        .collection('users')
        .document(selectedUserId)
        .collection('chats')
        .document(currentUserId)
        .setData({
      'timestamp': DateTime.now(),
    });
    await _fireStore
        .collection('users')
        .document(currentUserId)
        .collection('matchedlist')
        .document(selectedUserId)
        .delete();
    await _fireStore
        .collection('users')
        .document(selectedUserId)
        .collection('matchedlist')
        .document(currentUserId)
        .delete();
  }

  Future selectUser(currentUserId, selectedUserId, selectedUserName,
      selectedUserPhotoUrl, currentUserName, currentUserPhotoUrl) async {
    deleteUser(currentUserId, selectedUserId);

    await _fireStore
        .collection('users')
        .document(currentUserId)
        .collection('matchedlist')
        .document(selectedUserId)
        .setData({
      'name': selectedUserName,
      'photourl': selectedUserPhotoUrl,
    });
    return await _fireStore
        .collection('users')
        .document(selectedUserId)
        .collection('matchedlist')
        .document(currentUserId)
        .setData({
      'name': currentUserName,
      'photourl': currentUserPhotoUrl,
    });
  }

  void deleteUser(currentUserId, selectedUserId) async {
    return await _fireStore
        .collection('users')
        .document(currentUserId)
        .collection('selectedlist')
        .document(selectedUserId)
        .delete();
  }
}
