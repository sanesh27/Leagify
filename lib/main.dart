import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leagify/mobile/home_screen.dart';
import 'package:leagify/mobile/sign_in_page.dart';
import 'package:leagify/pages/login_page.dart';
import 'package:leagify/services/shared_services.dart';
import 'package:leagify/widget_tree.dart';
import 'package:dio/dio.dart';
import 'mobile/game_details_post.dart';

Widget _defaultHome =  LoginPage();


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoogedIn();
  if(_result){
    _defaultHome =  HomeScreen();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leagify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(),
      routes: {
    '/' : (context) => _defaultHome,
    '/home' : (context) => HomeScreen(),

      },
    );
  }
}



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Leagify"),
//       // ),
//       body: WidgetTree(),
//       // body: LayoutBuilder(
//       //   builder: (context,constraints) {
//       //     if(constraints.maxWidth < 600){
//       //       return MobileHomeScreen();
//       //     }else{
//       //
//       //       return const Center(child: Text("None!"),);
//       //     }
//       //
//       //   }
//       );
//
//   }
// }
