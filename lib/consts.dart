import 'package:flutter/material.dart';

const kScaffoldBackGroundColor = Color(0xFFDC143C);

void pageScroll(Widget pageName, context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return pageName;
      },
    ),
  );
}
