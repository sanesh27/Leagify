import 'package:shared_preferences/shared_preferences.dart';

// Preference Constants
const String FIRST_LOGIN = "first_login";

class MySharedPrefs {
  Future<SharedPreferences> sharedPreference;

  MySharedPrefs(this.sharedPreference);

  Future<String> getString(String key, String defaultValue) async {
    return (await sharedPreference).getString(key) ?? defaultValue;
  }

  Future<int> getInt(String key, int defaultValue) async {
    return (await sharedPreference).getInt(key) ?? defaultValue;
  }

  Future<bool> getBool(String key, bool defaultValue) async {
    return (await sharedPreference).getBool(key) ?? defaultValue;
  }

  Future<void> setString(String key, String value) async {
    (await sharedPreference).setString(key, value);
  }

  Future<void> setInt(String key, int value) async {
    (await sharedPreference).setInt(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    (await sharedPreference).setBool(key, value);
  }

  Future<bool> clearSharedPrefs() async {
    sharedPreference = SharedPreferences.getInstance();

    return (await sharedPreference).remove(FIRST_LOGIN);
  }
}