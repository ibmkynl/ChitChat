import 'package:chitchat/Models/Chat.dart';
import 'package:chitchat/Models/Message.dart';
import 'package:chitchat/Models/User.dart';
import 'package:chitchat/Pages/Messaging_Page.dart';
import 'package:chitchat/Repo/messagesRepo.dart';
import 'package:chitchat/Widgets/Photo_Widget.dart';
import 'package:chitchat/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  final String userId, selectedUserId;
  final Timestamp creationTime;
  ChatWidget({
    this.creationTime,
    this.userId,
    this.selectedUserId,
  });

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  MessagesRepo messagesRepo = new MessagesRepo();
  Chat chatModel;
  User user;
  getUserDetail() async {
    user = await messagesRepo.getUserDetail(userId: widget.selectedUserId);
    Message message = await messagesRepo
        .getLastMessage(
            currentUserId: widget.userId, selectedUserId: widget.selectedUserId)
        .catchError((error) {
      print(error);
    });

    if (message == null) {
      return Chat(
          name: user.name,
          photoUrl: user.photo,
          lastMessage: null,
          lastMessagePhoto: null,
          timestamp: null);
    } else {
      return Chat(
          name: user.name,
          photoUrl: user.photo,
          lastMessage: message.text,
          lastMessagePhoto: message.photoUrl,
          timestamp: message.timeStamp);
    }
  }

  openChat() async {
    User currentUser = await messagesRepo.getUserDetail(userId: widget.userId);
    User selectedUser =
        await messagesRepo.getUserDetail(userId: widget.selectedUserId);
    try {
      pageScroll(
          MessagingPage(
            currentUser: currentUser,
            selectedUser: selectedUser,
          ),
          context);
    } catch (e) {
      print(e.toString());
    }
  }

  deleteChat() async {
    await messagesRepo.deleteChat(
        currentUserId: widget.userId, selectedUserId: widget.selectedUserId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUserDetail(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container();
          } else {
            Chat chat = snap.data;
            return GestureDetector(
              onTap: () async {
                await openChat();
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: Wrap(
                            children: <Widget>[
                              Text("Do you want to delete this chat ?"),
                              Text(
                                "You will not able to recover this chat",
                                style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "No",
                                style:
                                    TextStyle(color: kScaffoldBackGroundColor),
                              ),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await deleteChat();
                              },
                              child: Text(
                                "Yes",
                                style:
                                    TextStyle(color: kScaffoldBackGroundColor),
                              ),
                            )
                          ],
                        ));
              },
              child: Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.height * 0.02)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                              height: size.height * 0.06,
                              width: size.height * 0.06,
                              child: PhotoWidget(
                                photoLink: user.photo,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user.name,
                                style: TextStyle(fontSize: size.height * 0.03),
                              ),
                              chat.lastMessage != null
                                  ? Text(
                                      chat.lastMessage,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(color: Colors.grey[600]),
                                    )
                                  : chat.lastMessagePhoto == null
                                      ? Text("Chat room opened")
                                      : Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.photo,
                                              color: Colors.grey,
                                              size: size.height * 0.02,
                                            ),
                                            Text(
                                              "Photo",
                                              style: TextStyle(
                                                  fontSize: size.height * 0.015,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        )
                            ],
                          ),
                        ],
                      ),
                      chat.timestamp != null
                          ? Text(chat.timestamp.toDate().hour.toString() +
                              ":" +
                              chat.timestamp.toDate().minute.toString())
                          : Text(widget.creationTime.toDate().hour.toString() +
                              ":" +
                              widget.creationTime.toDate().minute.toString()),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
