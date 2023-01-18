import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leagify/pages/login_page.dart';

import '../models/login_response_model.dart';
import '../models/player_image.dart';

class SharedService {
  static Future<bool> isLoogedIn() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("login_details");
    return isKeyExist;
  }
  static Future<bool> hasImage() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("player_images");
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

  static Future<Map> cachedPlayerImages()  async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist(
        "player_images");
    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData("player_images");
      return jsonDecode(cacheData.syncData);
    } else {
      return {};
    }
  }

    static Future<void> setLoginDetails(LoginResponseModel model) async {
      APICacheDBModel cacheDBModel = APICacheDBModel(key: "login_details", syncData: jsonEncode(model.toJson()));
      await APICacheManager().addCacheData(cacheDBModel);

    }

    static Future<void> setPlayerImages(Map<String, dynamic> data) async {
      APICacheDBModel cacheDBModel = APICacheDBModel(key: "player_images", syncData: jsonEncode(data));
      await APICacheManager().addCacheData(cacheDBModel);

    }

    static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login_details");
    print("Logged out, Navigating to root directory");
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
