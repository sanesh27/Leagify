
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:leagify/constants.dart';
import 'package:leagify/models/login_request.dart';
import 'package:leagify/services/api_service.dart';
import 'package:leagify/services/my_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';



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

  @override
  void initState() {
    // _canCheckBiometrics();
    // _readCredential();
    _getBioWidget();
    _checkBiometric();
    _getAvailableBiometric();
    super.initState();
  }

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
          useErrorDialogs: true
        ),
        authMessages: [],
      );
      if (authenticated) {
        await _readCredential().then((value) {

          login(setBioMetric: true);
        });
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
        "Login Cancelled",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
        backgroundColor: Colors.red,
      ));
    }
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
    _getBioWidget();
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: LayoutBuilder(
        builder: (context,constraints) {
          double height = constraints.maxHeight;
          return Column(
            children: [
              SizedBox(
                height: height * 0.15,
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
                height: height * 0.30,
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
                                _checkFirsTimeLogin();
                              },
                          btnColor: kButtonColor,
                          txtColor: kButtonTextColor,
                          borderRadius: 16,
                          borderColor: kCanvasColor
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: isFirstTimeLogin,
                      child: InkWell(
                        onTap: () {
                          _authenticate();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Biometric login ",
                                style: kGreetingStyle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              Image.asset(
                                "assets/fingerprint.png",
                                height: 20.0,
                                width: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  bool isFirstTimeLogin = false;
  _checkFirsTimeLogin() async {
    String name = await _storage.read(key: _userKey) ?? "";
    String pwd = await _storage.read(key: _passwordKey) ?? "";
    if ((name != username) && (pwd != password)) {
      isFirstTimeLogin = await MySharedPrefs(SharedPreferences.getInstance()).getBool(FIRST_LOGIN, false);
        if (validateAndSave() && _canCheckBiometric) {
          biometricUserPrompt();
        } else {
          if (validateAndSave()) {
            login();
          }
        }
    } else {
      if(validateAndSave()) {
        login();
      }
    }

  }

  Future<void> _getBioWidget() async {
    isFirstTimeLogin = await MySharedPrefs(SharedPreferences.getInstance()).getBool(FIRST_LOGIN, false);
  }

  login({bool setBioMetric = false}) async {
      setState(() {
        isAPIcallProgress = true;
      });
      LoginRequestModel model = LoginRequestModel(username: username!, password: password!,email: username!,image: 'dummyimage');
          isFirstTimeLogin = await MySharedPrefs(SharedPreferences.getInstance()).getBool(FIRST_LOGIN, false);
      APIService.login(model).then((response) async {
        if (response)  {
        _saveCredentials();
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        else {
          FormHelper.showSimpleAlertDialog(context, "Leagify App", "Please check your connectivity and User/Pass", "Ok", (){
            Navigator.pop(context);
            setState(() {
              isAPIcallProgress = false;
            });
          });
        }
      });
  }

  biometricUserPrompt() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Do you want to enable biometric login?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        login();
                      },
                      child: Expanded(
                        // flex: 2,
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Center(
                            child:  Text('No',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        await MySharedPrefs(SharedPreferences.getInstance()).setBool(FIRST_LOGIN, true);
                        login();
                      },
                      child: Expanded(
                        // flex: 2,
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Center(
                            child:  Text('Yes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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