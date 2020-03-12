import 'package:bloc/bloc.dart';
import 'package:chitchat/MessageBloc/Bloc.dart';
import 'package:chitchat/Repo/messagesRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessagesRepo _messagesRepo;

  MessageBloc({@required MessagesRepo messagesRepo})
      : assert(messagesRepo != null),
        _messagesRepo = messagesRepo;

  @override
  MessageState get initialState => MessageInitialState();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is ChatStreamEvent) {
      yield* _mapStreamToState(currentId: event.currentUserId);
    }
  }

  Stream<MessageState> _mapStreamToState({currentId}) async* {
    yield ChatLoadingState();
    Stream<QuerySnapshot> chatStream =
        _messagesRepo.getChats(userId: currentId);
    yield ChatLoadedState(chatStream: chatStream);
  }
}
