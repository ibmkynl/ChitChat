import 'package:chitchat/Models/Message.dart';
import 'package:chitchat/Repo/messagingRepo.dart';
import 'package:chitchat/Widgets/Photo_Widget.dart';
import 'package:chitchat/consts.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final String messageId;
  final String currentUserId;

  MessageWidget({
    this.messageId,
    this.currentUserId,
  });

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  MessagingRepo _messagingRepo = new MessagingRepo();
  Message _message;
  Future getDetails() async {
    _message =
        await _messagingRepo.getMessageDetail(messageId: widget.messageId);

    return _message;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getDetails(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container();
          } else {
            _message = snap.data;
            return Column(
              crossAxisAlignment: _message.senderId == widget.currentUserId
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                _message.text != null
                    ? Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          _message.senderId == widget.currentUserId
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: Text(_message.timeStamp
                                          .toDate()
                                          .hour
                                          .toString() +
                                      ":" +
                                      _message.timeStamp
                                          .toDate()
                                          .minute
                                          .toString()),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.all(size.height * 0.01),
                            child: ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: size.width * 0.7),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: _message.senderId == widget.currentUserId
                                        ? kScaffoldBackGroundColor
                                        : Colors.grey[300],
                                    borderRadius: _message.senderId ==
                                            widget.currentUserId
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(
                                                size.height * 0.02),
                                            topRight: Radius.circular(
                                                size.height * 0.02),
                                            bottomLeft: Radius.circular(
                                                size.height * 0.02))
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(
                                                size.height * 0.02),
                                            topRight:
                                                Radius.circular(size.height * 0.02),
                                            bottomRight: Radius.circular(size.height * 0.02))),
                                padding: EdgeInsets.all(size.height * 0.01),
                                child: Text(
                                  _message.text,
                                  style: TextStyle(
                                      color: _message.senderId ==
                                              widget.currentUserId
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          _message.senderId == widget.currentUserId
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: Text(_message.timeStamp
                                          .toDate()
                                          .hour
                                          .toString() +
                                      ":" +
                                      _message.timeStamp
                                          .toDate()
                                          .minute
                                          .toString()),
                                ),
                        ],
                      )
                    : Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          _message.senderId == widget.currentUserId
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: Text(_message.timeStamp
                                          .toDate()
                                          .hour
                                          .toString() +
                                      ":" +
                                      _message.timeStamp
                                          .toDate()
                                          .minute
                                          .toString()),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.all(size.height * 0.01),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: size.width * 0.7,
                                  maxHeight: size.height * 0.8),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kScaffoldBackGroundColor),
                                    borderRadius: BorderRadius.circular(
                                        size.height * 0.02)),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(size.height * 0.02),
                                  child: PhotoWidget(
                                    photoLink: _message.photoUrl,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _message.senderId == widget.currentUserId
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: Text(_message.timeStamp
                                          .toDate()
                                          .hour
                                          .toString() +
                                      ":" +
                                      _message.timeStamp
                                          .toDate()
                                          .minute
                                          .toString()),
                                ),
                        ],
                      ),
              ],
            );
          }
        });
  }
}
