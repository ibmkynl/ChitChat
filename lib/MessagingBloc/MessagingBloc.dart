import 'package:bloc/bloc.dart';
import 'package:chitchat/MessagingBloc/Bloc.dart';
import 'package:chitchat/Repo/messagingRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingRepo _messagingRepo;

  MessagingBloc({@required MessagingRepo messagingRepo})
      : assert(messagingRepo != null),
        _messagingRepo = messagingRepo;

  @override
  MessagingState get initialState => MessageInitialState();

  @override
  Stream<MessagingState> mapEventToState(MessagingEvent event) async* {
    if (event is MessageStreamEvent) {
      yield* _mapStreamToState(
          currentId: event.currentUserId, selectedId: event.selectedUserId);
    }
    if (event is SendMessageEvent) {
      yield* _mapSendMessageToState(message: event.message);
    }
  }

  Stream<MessagingState> _mapStreamToState({currentId, selectedId}) async* {
    yield MessagingLoadingState();
    Stream<QuerySnapshot> messageStream = _messagingRepo.getMessages(
        currentUserId: currentId, selectedUserId: selectedId);
    yield MessagingLoadedState(messageStream: messageStream);
  }

  Stream<MessagingState> _mapSendMessageToState({message}) async* {
    await _messagingRepo.sendMessage(message: message);
  }
}
