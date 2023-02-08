import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as client;
import 'package:leagify/models/game_response.dart';



import 'package:leagify/models/login_request.dart';
import 'package:leagify/config.dart';
import 'package:leagify/models/login_response_model.dart';
import 'package:leagify/models/match_list.dart';
import 'package:leagify/models/player_stats.model.dart';
import 'package:leagify/models/stats_post.dart';
import 'package:leagify/services/shared_services.dart';

import '../models/player.dart';
import '../models/result_model.dart';
import 'package:connectivity/connectivity.dart';


class APIService {


  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }else{
      print("Connected to the internet");
      var url = Uri.http(Config.apiURL, Config.loginAPI);
      var response = await client.post(url,
          headers: requestHeaders, body: jsonEncode(model.toJson()));
      if (response.statusCode == 200) {

        await SharedService.setLoginDetails(loginResponsejson(response.body));
        return true;
      } else {
        print("user pass not right");
        return false;
      }
    }

  }


   static Future<String> postStats (StatsPost jsondata) async {
     Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
     var url = Uri.http(Config.apiURL, Config.postStats);
     var response = await client.post(url,
         headers: requestHeaders, body: jsonEncode(jsondata.toJson()));
     return response.statusCode.toString();

  }




  static Future<bool> players() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.profile);
    var response = await client.get(url,
        headers: requestHeaders,);
    Map<String, dynamic> mapData = jsonDecode(response.body);
    SharedService.setPlayerImages(mapData);
    if (response.statusCode == 200) {
      // await SharedService.setPlayerImages(PlayerImage(data: mapData));
      return true;
    } else {
      return false;
    }
  }



  static Future<List<MatchList>> getMatchCards() async {
    // var loginDetails = await SharedService.loginDetails();
    // print(loginDetails!.jwt);
    Map<String, String> requestHeaders = {
      'content-Type': 'application/json',
      // 'authorization' : '${loginDetails!.jwt}'
    };

    var url = Uri.http(Config.apiURL, Config.matches);
    debugPrint('calling ${url}');
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      List<dynamic> listResponse = jsonDecode(response.body);
      List<MatchList> listMatch =
          List<MatchList>.from(listResponse.map((e) => MatchList.fromJson(e)));
      return listMatch;
    } else {
      return [];
    }
  }


  static Future<GameResponse> getGameResponse(id) async {
    // var loginDetails = await SharedService.loginDetails();
    // print(loginDetails!.jwt);
    Map<String, String> requestHeaders = {
      'content-Type': 'application/json',
      // 'authorization' : '${loginDetails!.jwt}'
    };
    var url = Uri.http(Config.apiURL, Config.getGame + id.toString());
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var listResponse = jsonDecode(response.body);
      GameResponse listMatch =
          GameResponse.fromJson(listResponse);
      return listMatch;
    } else {
      return GameResponse(gameId: 0, team1Name: '', team2Name: '', team1Id: 0, team2Id: 0);
    }
  }


  static Future<List<Player>> getPlayers(int teamId) async {
    // var loginDetails = await SharedService.loginDetails();
    // print(loginDetails!.jwt);
    Map<String, String> requestHeaders = {
      'content-Type': 'application/json',
      // 'authorization' : '${loginDetails!.jwt}'
    };
    // print(teamId);
    var url = Uri.http(Config.apiURL, Config.playerByTeam + teamId!.toString());
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var listResponse = jsonDecode(response.body);
      List<Player> listMatch =
          List<Player>.from(listResponse.map((e) => Player.fromJson(e)));
      return listMatch;
    } else {
      return [];
    }
  }

  static Future<String> getMatchDetails(int teamId) async {
    // var loginDetails = await SharedService.loginDetails();
    // print(loginDetails!.jwt);
    Map<String, String> requestHeaders = {
      'content-Type': 'application/json',
      // 'authorization' : '${loginDetails!.jwt}'
    };

    // print(teamId);
    var url = Uri.http(Config.apiURL, Config.matchDetails + teamId!.toString());
    debugPrint('calling getMatchdetails $url' );
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      String matchURL = jsonDecode(response.body);
      return matchURL;
    } else {
      return '';
    }
  }

  static Future<List<TeamStanding>> getStandings() async {
    // var loginDetails = await SharedService.loginDetails();
    // print(loginDetails!.jwt);
    Map<String, String> requestHeaders = {
      'content-Type': 'application/json',
      // 'authorization' : '${loginDetails!.jwt}'
    };
    var url = Uri.http(Config.apiURL, Config.standings);
    var apiResponse = await client.get(url, headers: requestHeaders);

    if (apiResponse.statusCode == 200) {
      Map newResponse = jsonDecode(apiResponse.body);

      List<TeamStanding> teamStanding = [];
      newResponse.forEach((key, value) {
        String logoURL = 'https://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Liverpool_FC.svg/1200px-Liverpool_FC.svg.png';
        if (key == "The Dudes"){
           logoURL = 'https://api.nepalipatro.com.np/storage/banners/VxWkNmZUX4J8cWF7.png';
        }
        if (key == "The Bokas"){
           logoURL = 'https://api.nepalipatro.com.np/storage/banners/92S3aQ4Q21kGAp0O.png';
        }
        if (key == "The Boros"){
           logoURL = 'https://api.nepalipatro.com.np/storage/banners/gVdtU8FSggphsBLh.png';
        }
        if (key == "The Goats"){
           logoURL = 'https://api.nepalipatro.com.np/storage/banners/l3SvljMmHBYIJykI.png';
        }


        newResponse[key]["win"] = newResponse[key]["win"] ?? 0;
        newResponse[key]["draw"] = newResponse[key]["draw"] ?? 0;
        newResponse[key]["played"] = newResponse[key]["played"] ?? 0;
        newResponse[key]["loss"] = newResponse[key]["loss"] ?? 0;
        newResponse[key]["GF"] = newResponse[key]["GF"] ?? 0;
        newResponse[key]["GA"] = newResponse[key]["GA"] ?? 0;
        newResponse[key]["GD"] = (newResponse[key]["GF"] - newResponse[key]["GA"]) ?? 0;
        newResponse[key]["logoURL"] = logoURL;
        newResponse[key]["points"] = newResponse[key]["win"]* 3 + newResponse[key]["draw"] ;


        var newJson = {key.toString() : value };
        teamStanding.add(TeamStanding.fromJson(newJson));
      });

      // print(teamStanding);
      // List<TeamStanding> teamStandings = jsonDecode(apiResponse.body).map((team) => TeamStanding.fromJson(team)).toList();
      return teamStanding;
    } else {
      return [];
    }
  }
  static Future<List<PlayerStats>> getGoals() async {
    // var loginDetails = await SharedService.loginDetails();
    // print(loginDetails!.jwt);
    Map<String, String> requestHeaders = {
      'content-Type': 'application/json',
      // 'authorization' : '${loginDetails!.jwt}'
    };
    var url = Uri.http(Config.apiURL, Config.goals);
    var apiResponse = await client.get(url, headers: requestHeaders);

    if (apiResponse.statusCode == 200) {
      Map newResponse = jsonDecode(apiResponse.body);
      //{"Saurav":{"Goal":1},"Bikram":{"Goal":2,"Assists":1},"Samin":{"Goal":1,"Assists":2},"Niraj":{"Goal":1},"Shivlal":{"Goal":1},"Shiv":{"Yellow":1},"Dilli":{"Assists":1}}

      List<PlayerStats> playerStats = [];
      newResponse.forEach((key, value) {

      playerStats.add(PlayerStats(name: key, goal: newResponse[key]["Goal"] ?? 0, assists: newResponse[key]["Assists"] ?? 0, yellow: newResponse[key]["Yellow"] ?? 0, red: newResponse[key]["Red"] ?? 0,team: newResponse[key]["team"] ));

      });

      // print(teamStanding);
      // List<TeamStanding> teamStandings = jsonDecode(apiResponse.body).map((team) => TeamStanding.fromJson(team)).toList();
      return playerStats;
    } else {
      return [];
    }
  }
}
