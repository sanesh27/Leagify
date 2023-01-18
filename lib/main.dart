
import 'package:flutter/material.dart';
import 'package:leagify/mobile/home_screen.dart';
import 'package:leagify/pages/login_page.dart';
import 'package:leagify/services/shared_services.dart';


Widget _defaultHome =  LoginPage();


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoogedIn();
  if(_result){
    _defaultHome =  const HomeScreen();
  }



  runApp(const MyApp());
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
    '/home' : (context) => const HomeScreen(),

      },
    );
  }
}
