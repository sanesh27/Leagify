import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leagify/constants.dart';
import 'package:leagify/models/login_request.dart';
import 'package:leagify/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProgress = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCanvasColor,
      body: ProgressHUD(
        key: UniqueKey(),
        inAsyncCall: isAPIcallProgress,
        child: Form(
          key: globalFormKey,
          child: _loginUI(context),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        double height = constraints.maxHeight;
        return Column(
          children: [
            SizedBox(
              height: height * 0.25,
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
                    style: kHeading(const Color(0xFF3AA365),height),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.35,
              child: const Image(
                image: AssetImage("assets/champions.png"),
              ),
            ),
            SizedBox(
              height: height * 0.4,
              child: Column(

                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormHelper.inputFieldWidget(
                    context,
                    "Username",
                    "Username",
                        (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return "username cant be empty";
                      }
                      return null;
                    },
                        (onSavedVal) {
                      username = onSavedVal;
                    },
                    borderColor: kCanvasColor,
                    suffixIcon: const Icon(
                      Icons.person,
                    ),
                    borderFocusColor: kBrandColor,
                    textColor: Colors.black54,
                    hintColor: Colors.black12,
                    borderRadius: 16,

                    backgroundColor: kScoreFutureMatch,
                    prefixIconColor: Colors.black12,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FormHelper.inputFieldWidget(
                    context,
                    "password",
                    "Password",
                        (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return "Password cant be empty";
                      }
                      return null;
                    },
                        (onSavedVal) {
                      password = onSavedVal;
                    },
                    borderColor: kCanvasColor,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                          hidePassword ? Icons.visibility_off : Icons.visibility),
                    ),
                    borderFocusColor: kBrandColor,
                    textColor: Colors.black54,
                    hintColor: Colors.black12,
                    borderRadius: 16,
                    backgroundColor: kScoreFutureMatch,
                    obscureText: hidePassword,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: FormHelper.submitButton(
                        "Login",
                            () {

                          if(validateAndSave()){
                            setState(() {
                              isAPIcallProgress = true;
                            });
                            LoginRequestModel model = LoginRequestModel(username: username!, password: password!,email: username!,image: 'dummyimage');
                            APIService.login(model).then((response) => {
                              if(response){
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false)
                              }
                              else {
                                FormHelper.showSimpleAlertDialog(context, "Leagify App", "Please check your connectivity and User/Pass", "Ok", (){
                                  Navigator.pop(context);
                                  setState(() {
                                    isAPIcallProgress = false;
                                  });


                                })
                              }
                            });
                          }
                            },
                        btnColor: kButtonColor,
                        txtColor: kButtonTextColor,
                        borderRadius: 16,
                        borderColor: kCanvasColor
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  bool validateAndSave() {

    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}