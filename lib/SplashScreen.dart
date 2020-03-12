import 'package:flutter/material.dart';
import 'consts.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kScaffoldBackGroundColor,
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: Text(
            "ChitChat",
            style: TextStyle(
                fontFamily: 'Coiny',
                fontSize: size.width * 0.2,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
