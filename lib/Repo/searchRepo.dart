import 'package:chitchat/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepo {
  final Firestore _fireStore;

  SearchRepo({
    Firestore fireStore,
  }) : _fireStore = fireStore ?? Firestore.instance;

  Future<User> chooseUser(currentUserId, selectedUserId, name, photoUrl) async {
    await _fireStore
        .collection('users')
        .document(currentUserId)
        .collection('choosedlist')
        .document(selectedUserId)
        .setData({});

    await _fireStore
        .collection('users')
        .document(selectedUserId)
        .collection('choosedlist')
        .document(currentUserId)
        .setData({});

    await _fireStore
        .collection('users')
        .document(selectedUserId)
        .collection('selectedlist')
        .document(currentUserId)
        .setData({
      'name': name,
      'photourl': photoUrl,
    });
    return getUser(currentUserId);
  }

  Future<User> passUser(currentUserId, selectedUserId) async {
    await _fireStore
        .collection('users')
        .document(selectedUserId)
        .collection('choosedlist')
        .document(currentUserId)
        .setData({});
    await _fireStore
        .collection('users')
        .document(currentUserId)
        .collection('choosedlist')
        .document(selectedUserId)
        .setData({});
    return getUser(currentUserId);
  }

  Future<User> getUser(userId) async {
    User _user = new User();
    List<String> choosedList = await getChoosedList(userId);
    User currentUser = await getUserInterests(userId);
    await _fireStore.collection('users').getDocuments().then((users) {
      for (var user in users.documents) {
        if ((!choosedList.contains(user.documentID)) &&
            (user.documentID != userId) &&
            (currentUser.interestedGender == user['gender']) &&
            (user['interestedgender'] == currentUser.gender)) {
          _user.uid = user.documentID;
          _user.name = user['name'];
          _user.photo = user['photourl'];
          _user.age = user['age'];
          _user.location = user['location'];
          _user.gender = user['gender'];
          _user.interestedGender = user['interestedgender'];
          break;
        }
      }
    });

    return _user;
  }

  Future getChoosedList(userId) async {
    List<String> choosedList = [];
    await _fireStore
        .collection('users')
        .document(userId)
        .collection('choosedlist')
        .getDocuments()
        .then((docs) {
      for (var doc in docs.documents) {
        if (docs.documents != null) {
          choosedList.add(doc.documentID);
        }
      }
    });

    return choosedList;
  }

  Future getUserInterests(userId) async {
    User currentUser = new User();
    await _fireStore.collection('users').document(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photourl'];
      currentUser.gender = user['gender'];
      currentUser.interestedGender = user['interestedgender'];
    });
    return currentUser;
  }
}
