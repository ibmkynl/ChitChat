import 'package:chitchat/MessageBloc/Bloc.dart';
import 'package:chitchat/Repo/messagesRepo.dart';
import 'package:chitchat/Widgets/Chat_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesPage extends StatefulWidget {
  final String userId;

  MessagesPage({
    this.userId,
  });

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  MessagesRepo _messagesRepo = new MessagesRepo();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = new MessageBloc(messagesRepo: _messagesRepo);
    super.initState();
  }

  @override
  void dispose() {
    _messageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _messageBloc,
        builder: (BuildContext context, MessageState state) {
          if (state is MessageInitialState) {
            _messageBloc
                .dispatch(ChatStreamEvent(currentUserId: widget.userId));
          }
          if (state is ChatLoadingState) {
            return LinearProgressIndicator();
          }

          if (state is ChatLoadedState) {
            Stream<QuerySnapshot> chatStream = state.chatStream;

            return StreamBuilder<QuerySnapshot>(
              stream: chatStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("No data");
                }
                if (snapshot.data.documents.isNotEmpty) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChatWidget(
                            creationTime: snapshot
                                .data.documents[index].data['timestamp'],
                            userId: widget.userId,
                            selectedUserId:
                                snapshot.data.documents[index].documentID,
                          );
                        });
                  }
                } else {
                  return Text("You dont have friend");
                }
              },
            );
          }

          return Container();
        });
  }
}
