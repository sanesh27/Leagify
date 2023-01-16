import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leagify/pages/login_page.dart';

import '../models/login_response_model.dart';

class SharedService {
  static Future<bool> isLoogedIn() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("login_details");
    return isKeyExist;
  }

  static Future<LoginResponseModel?> loginDetails()  async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist(
        "login_details");
    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData("login_details");
      return loginResponsejson(cacheData.syncData);
    }
  }

    static Future<void> setLoginDetails(LoginResponseModel model) async {
      APICacheDBModel cacheDBModel = APICacheDBModel(key: "login_details", syncData: jsonEncode(model.toJson()));
      await APICacheManager().addCacheData(cacheDBModel);

    }

    static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login_details");
    print("Logged out, Navigating to root directory");
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
