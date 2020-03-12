import 'package:flutter/material.dart';

import 'Photo_Widget.dart';

Widget profileWidget(
    {padding,
    photoHeight,
    photoWidth,
    clipRadius,
    photo,
    containerHeight,
    containerWidth,
    child}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
            offset: Offset(
              10.0, // horizontal, move right 10
              10.0, // vertical, move down 10
            ),
          )
        ],
        borderRadius: BorderRadius.circular(clipRadius),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
              width: photoWidth,
              height: photoHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(clipRadius),
                child: PhotoWidget(
                  photoLink: photo,
                ),
              )),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black54,
                Colors.black87,
                Colors.black,
              ], stops: [
                0.1,
                0.2,
                0.4,
                0.9
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              color: Colors.black45,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(clipRadius),
                  bottomRight: Radius.circular(clipRadius)),
            ),
            width: containerWidth,
            height: containerHeight,
            child: child,
          ),
        ],
      ),
    ),
  );
}
