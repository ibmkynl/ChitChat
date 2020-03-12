import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String name;
  String photoUrl;
  String lastMessagePhoto;
  Timestamp timestamp;
  String lastMessage;

  Chat({
    this.lastMessagePhoto,
    this.photoUrl,
    this.name,
    this.timestamp,
    this.lastMessage,
  });
}
