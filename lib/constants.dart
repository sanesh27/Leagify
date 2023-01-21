

import 'dart:typed_data';

import 'package:flutter/material.dart';

Color kBrandColor = const Color(0xFF3AA365);
Color kCanvasColor = Color(0xFFEEEEEE);
Color kScoreStyle = const Color(0xFF666666);
Color kScoreFutureMatch = const Color(0xFFDDDDDD);
Color kTableDividerColor = const Color(0xFFEEEEEE);
Color kTableHeaderStyle = const Color(0xFFAAAAAA);
Color kButtonTextColor = const Color(0xFFEEEEEE);
Color kButtonColor = const Color(0xFF0065CC);
Color kGreetingColor = const Color(0xFF888888);
Color kDescriptionStyle = const Color(0xFFAAAAAA);
TextStyle kHeading(Color color,double height) {
  return TextStyle(
      fontFamily: "Helvetica Neue",
      fontSize: height * 0.04,
      color: color,
      fontWeight: FontWeight.bold);
}



TextStyle kLargeSubtitle =  TextStyle(
    fontFamily: "Helvetica Neue", fontSize: 16.0, fontWeight: FontWeight.bold,color: kScoreStyle);
TextStyle kNormalSize =  TextStyle(
    fontFamily: "Helvetica Neue", fontSize: 12.0, fontWeight: FontWeight.bold,color: kScoreStyle);
TextStyle kSmallSubtitle =  TextStyle(
    fontFamily: "Helvetica Neue", fontSize: 8.0, fontWeight: FontWeight.bold, color: kDescriptionStyle);
TextStyle kGreetingStyle = const TextStyle(
    fontFamily: "Helvetica Neue", fontSize: 12.0, fontWeight: FontWeight.bold,color: Color(0xFF888888));

ButtonStyle kButtonStyle() {
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: kButtonColor)),
    ),
  );
}

TextField kField(String hint,bool obscure) {
  return TextField(
    autocorrect: false,
    cursorColor: kButtonColor ,
    decoration: InputDecoration(
      hintText: hint,

    ),
    obscureText: obscure,
  );
}

// Unit8List kTransparentImage = Image.memory(Uint8List.fromList([0]), width: 1.0, height: 1.0, fit: BoxFit.cover);