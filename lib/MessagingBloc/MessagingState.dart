import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessagingState extends Equatable {
  MessagingState([List props = const []]) : super();
}

class MessageInitialState extends MessagingState {
  @override
  List<Object> get props => [];
}

class MessagingLoadingState extends MessagingState {
  @override
  List<Object> get props => [];
}

class MessagingLoadedState extends MessagingState {
  final Stream<QuerySnapshot> messageStream;

  MessagingLoadedState({this.messageStream});

  @override
  List<Object> get props => [messageStream];
}
