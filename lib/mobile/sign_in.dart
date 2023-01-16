import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leagify/auth.dart';
import 'package:leagify/constants.dart';
import 'package:leagify/services/leagify_api.dart';
import 'package:dio/dio.dart';
import 'package:leagify/models/users.dart';
import 'package:leagify/login_interface.dart';
import 'package:leagify/services/login_service.dart';
import 'package:leagify/mobile/home_screen.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final Users user = Users(name: '', token: '');
  final emailController = TextEditingController();
  final ILogin _loginService = LoginService();
  final passwordController = TextEditingController();
  String? errormessage = '';
  bool isLogin = true;
  LeagifyAPI api = LeagifyAPI();

  Future<void> signInWithEmailandPassword() async {
    print("Signing in");
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
        snackBar();
      });
    }
  }

  Widget entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: title),
    );
  }

  Widget errorMessage() {
    return Text(errormessage == '' ? '' : 'HUMM ? $errormessage');
  }

  Widget snackBar() {
    return Container(
      child: errorMessage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("please sign in");
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to",
                  style: kGreetingStyle,
                ),
                Text(
                  "Leagify!",
                  style: kHeading(Color(0xFF3AA365)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: const Image(
              image: AssetImage("assets/champions.png"),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  constraints.maxWidth * 0.1, 0, constraints.maxWidth * 0.1, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, constraints.maxHeight * 0.05, 0,
                    constraints.maxHeight * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Material(
                        child: TextField(
                      maxLines: 1,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Username",
                        fillColor: kButtonTextColor,
                      ),
                      controller: emailController,
                          textInputAction: TextInputAction.next,
                    )),
                    Material(
                      child: TextField(
                        maxLines: 1,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password", fillColor: kButtonTextColor),
                        controller: passwordController,textInputAction: TextInputAction.done,
                        onEditingComplete: ()async {
                            Users user = await _loginService.login(emailController.text, passwordController.text);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                        },
                      ),
                    ),

                    // ElevatedButton(
                    //   // Within the `FirstRoute` widget
                    //   onPressed: signInWithEmailandPassword,
                    //
                    //   child: Text("Sign In"),
                    //   style: kButtonStyle().copyWith(
                    //     elevation: MaterialStatePropertyAll(0),
                    //   ),
                    // ),
                    // Expanded(child:
                    //   FutureBuilder(future: LeagifyAPI().fetchUserToken(), builder: (context, snapshot){
                    //     if(snapshot.hasData){
                    //       return Center(child: Text(snapshot.data),);
                    //     } else {
                    //       print(snapshot);
                    //       return Center(child: Text("no data"),);
                    //     }
                    //   })
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
