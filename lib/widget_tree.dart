import 'package:firebase_auth/firebase_auth.dart';
import 'package:leagify/mobile/home_screen.dart';
import 'package:leagify/mobile/sign_in.dart';
import 'package:leagify/mobile/sign_in_page.dart';
import 'auth.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges,builder: (context,snapshot){
      print(snapshot.data);
        if(snapshot.hasData){

          return SignInPage();
        } else {
          return SignInPage();
        }
    },);
  }
}
