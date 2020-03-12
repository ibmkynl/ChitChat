import 'package:chitchat/Models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  MessageState([List props = const []]) : super();
}

class MessageInitialState extends MessageState {
  @override
  List<Object> get props => [];
}

class ChatLoadingState extends MessageState {
  @override
  List<Object> get props => [];
}

class ChatLoadedState extends MessageState {
  final Stream<QuerySnapshot> chatStream;

  ChatLoadedState({this.chatStream});

  @override
  List<Object> get props => [chatStream];
}
