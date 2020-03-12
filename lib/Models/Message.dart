import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderName;
  String senderId;
  String selectedUserId;
  String text;
  String photoUrl;
  File photo;
  Timestamp timeStamp;

  Message({
    this.text,
    this.senderName,
    this.senderId,
    this.photo,
    this.photoUrl,
    this.selectedUserId,
    this.timeStamp,
  });
}
