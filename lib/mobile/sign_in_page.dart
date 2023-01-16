import 'package:flutter/material.dart';
import 'package:leagify/constants.dart';
import 'package:leagify/mobile/sign_in.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.fromLTRB(constraints.maxWidth*0.1, 0 , constraints.maxWidth*0.1, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, constraints.maxHeight * 0.05, 0, constraints.maxHeight * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      // Within the `FirstRoute` widget
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  SignInPage()),
                        );
                      },
                      child: Text("Sign In"),
                      style: kButtonStyle().copyWith(
                    elevation: MaterialStatePropertyAll(0),
                      ),
                    ),
                  SizedBox(height: 16.0,),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text("Sign Up"),
                      style: kButtonStyle().copyWith(
                  elevation: MaterialStatePropertyAll(0),
                      ),
                    )
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


