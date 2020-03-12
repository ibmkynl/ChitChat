import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  MessageEvent([List props = const []]) : super();
}

class ChatStreamEvent extends MessageEvent {
  final String currentUserId;

  ChatStreamEvent({this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}
