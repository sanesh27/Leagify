import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:leagify/constants.dart';
import 'package:leagify/models/login_request.dart';
import 'package:leagify/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:local_auth/local_auth.dart';


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
  final _storage =  const FlutterSecureStorage();
  static const String _userKey = "username_key";
  static const String _passwordKey = "pwd_key";
  final LocalAuthentication _auth = LocalAuthentication();
  /*bool canAuthenticateWithBiometrics = false;
  bool canAuthenticate = false;*/

  @override
  void initState() {
    // _canCheckBiometrics();
    // _readCredential();
    _checkBiometric();
    _getAvailableBiometric();
    super.initState();
  }

  /*_canCheckBiometrics() async {
    canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    canAuthenticate = (canAuthenticateWithBiometrics || await _auth.isDeviceSupported());
  }*/

  /*_authenticateBio() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {

      } else if (e.code == auth_error.notEnrolled) {

      } else {}
    }
  }*/

    bool _canCheckBiometric = false;
  Future<void> _checkBiometric() async {
    bool canBiometric = false;
    try {
      canBiometric = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canBiometric;
    });
  }


    List<BiometricType> _availableBiometric = [];
  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];
    try {
      availableBiometric = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  String authorized = "";
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      print("herereeeeee");
      authenticated = await _auth.authenticate(
          localizedReason: "Scan your finger to authenticate",
        options: const AuthenticationOptions(
          useErrorDialogs: false
        ),
        authMessages: [],
      );
      await _readCredential();
      print("herereeeeee  ${authenticated.toString()}");
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      authorized = authenticated ? "Authorized success" : "Failed to authenticate";

      print(authorized);
    });
  }

  Future<void> _readCredential() async {
    username = await _storage.read(key: _userKey) ?? "";
    password = await _storage.read(key: _passwordKey) ?? "";
    print("Credential $username $password");
  }

  Future<void> _saveCredentials() async {
    String _userValue = username ?? "";
    String _passwordValue = password ?? "";

    await _storage.write(key: _userKey, value: _userValue);
    await _storage.write(key: _passwordKey, value: _passwordValue);
  }

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
                    initialValue: username ?? "",
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
                    initialValue: password ?? ""
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
                            _saveCredentials();
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: FormHelper.submitButton(
                        "Login Bio",
                            () {

                            _authenticate().then((value) {
                              _saveCredentials();
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
                            });

                          /*if(validateAndSave()){
                          }*/
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