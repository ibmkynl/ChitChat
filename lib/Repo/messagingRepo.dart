import 'package:chitchat/Models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessagingRepo {
  final Firestore _fireStore;
  final FirebaseStorage _firebaseStorage;

  MessagingRepo({
    Firestore fireStore,
    FirebaseStorage firebaseStorage,
  })  : _fireStore = fireStore ?? Firestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future sendMessage({Message message}) async {
    StorageUploadTask storageUploadTask;
    DocumentReference messageRef = _fireStore.collection('messages').document();
    CollectionReference senderRef = _fireStore
        .collection('users')
        .document(message.senderId)
        .collection('chats')
        .document(message.selectedUserId)
        .collection('messages');
    CollectionReference sendUserRef = _fireStore
        .collection('users')
        .document(message.selectedUserId)
        .collection('chats')
        .document(message.senderId)
        .collection('messages');

    if (message.photo != null) {
      StorageReference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.documentID)
          .child(message.photo.path);

      storageUploadTask = photoRef.putFile(message.photo);

      await storageUploadTask.onComplete.then((photo) async {
        await photo.ref.getDownloadURL().then((photoUrl) async {
          await messageRef.setData({
            'sendername': message.senderName,
            'senderid': message.senderId,
            'text': null,
            'photourl': photoUrl,
            'timestamp': DateTime.now(),
          });
        });
      });

      senderRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});

      sendUserRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});

      _fireStore
          .collection('users')
          .document(message.senderId)
          .collection('chats')
          .document(message.selectedUserId)
          .updateData({'timestamp': DateTime.now()});

      _fireStore
          .collection('users')
          .document(message.selectedUserId)
          .collection('chats')
          .document(message.senderId)
          .updateData({'timestamp': DateTime.now()});
    }
    if (message.text != null) {
      await messageRef.setData({
        'sendername': message.senderName,
        'senderid': message.senderId,
        'text': message.text,
        'photourl': null,
        'timestamp': DateTime.now(),
      });
      senderRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});

      sendUserRef
          .document(messageRef.documentID)
          .setData({'timestamp': DateTime.now()});
      await _fireStore
          .collection('users')
          .document(message.senderId)
          .collection('chats')
          .document(message.selectedUserId)
          .updateData({'timestamp': DateTime.now()});

      await _fireStore
          .collection('users')
          .document(message.selectedUserId)
          .collection('chats')
          .document(message.senderId)
          .updateData({'timestamp': DateTime.now()});
    }
  }

  Stream<QuerySnapshot> getMessages({currentUserId, selectedUserId}) {
    return _fireStore
        .collection('users')
        .document(currentUserId)
        .collection('chats')
        .document(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({messageId}) async {
    Message _message = new Message();
    await _fireStore
        .collection('messages')
        .document(messageId)
        .get()
        .then((message) {
      _message.senderId = message['senderid'];
      _message.senderName = message['sendername'];
      _message.timeStamp = message['timestamp'];
      _message.text = message['text'];
      _message.photoUrl = message['photourl'];
    });

    return _message;
  }
}
