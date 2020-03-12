import 'dart:io';

import 'package:chitchat/MessagingBloc/Bloc.dart';
import 'package:chitchat/Models/Message.dart';
import 'package:chitchat/Models/User.dart';
import 'package:chitchat/Repo/messagingRepo.dart';
import 'package:chitchat/Widgets/Message_Widget.dart';
import 'package:chitchat/Widgets/Photo_Widget.dart';
import 'package:chitchat/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MessagingPage extends StatefulWidget {
  final User currentUser, selectedUser;

  MessagingPage({
    this.selectedUser,
    this.currentUser,
  });

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  TextEditingController _messageTextController = new TextEditingController();
  MessagingRepo _messagingRepo = new MessagingRepo();
  MessagingBloc _messagingBloc;

  @override
  void initState() {
    _messagingBloc = MessagingBloc(messagingRepo: _messagingRepo);
    super.initState();
  }

  @override
  void dispose() {
    _messagingBloc.dispose();
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldBackGroundColor,
        elevation: size.height * 0.02,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipOval(
              child: Container(
                height: size.height * 0.06,
                width: size.height * 0.06,
                child: PhotoWidget(
                  photoLink: widget.selectedUser.photo,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            Expanded(child: Text(widget.selectedUser.name))
          ],
        ),
      ),
      body: BlocBuilder(
          bloc: _messagingBloc,
          builder: (BuildContext context, MessagingState state) {
            if (state is MessageInitialState) {
              _messagingBloc.dispatch(MessageStreamEvent(
                  currentUserId: widget.currentUser.uid,
                  selectedUserId: widget.selectedUser.uid));
            }
            if (state is MessagingLoadingState) {
              return Container(
                child: LinearProgressIndicator(),
              );
            }
            if (state is MessagingLoadedState) {
              Stream<QuerySnapshot> messageSteam = state.messageStream;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: messageSteam,
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        return Text("Wanna start the conversation ?");
                      }
                      if (snapshots.data.documents.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return MessageWidget(
                                currentUserId: widget.currentUser.uid,
                                messageId:
                                    snapshots.data.documents[index].documentID,
                              );
                            },
                            itemCount: snapshots.data.documents.length,
                          ),
                        );
                      } else {
                        return Center(
                            child: Text("Wanna start the conversation ?"));
                      }
                    },
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.06,
                    color: kScaffoldBackGroundColor,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            File photo =
                                await FilePicker.getFile(type: FileType.IMAGE);
                            if (photo != null) {
                              _messagingBloc.dispatch(SendMessageEvent(
                                  message: Message(
                                text: null,
                                senderId: widget.currentUser.uid,
                                senderName: widget.currentUser.name,
                                selectedUserId: widget.selectedUser.uid,
                                photo: photo,
                              )));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.005),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: size.height * 0.04,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          height: size.height * 0.05,
                          padding: EdgeInsets.all(size.height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(size.height * 0.04),
                          ),
                          child: Center(
                            child: TextField(
                              textInputAction: TextInputAction.send,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              decoration: null,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: kScaffoldBackGroundColor,
                              controller: _messageTextController,
                            ),
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            _messagingBloc.dispatch(SendMessageEvent(
                                message: Message(
                              text: _messageTextController.text,
                              senderId: widget.currentUser.uid,
                              senderName: widget.currentUser.name,
                              selectedUserId: widget.selectedUser.uid,
                              photo: null,
                            )));
                            _messageTextController.clear();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.01),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }

            return Container();
          }),
    );
  }
}
