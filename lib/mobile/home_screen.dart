import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_base_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:leagify/models/login_response_model.dart';
import 'package:leagify/models/match_list.dart';
import 'package:leagify/services/api_service.dart';
import 'package:leagify/services/shared_services.dart';
import '../auth.dart';
import '../constants.dart';
import 'package:leagify/models/users.dart';
import 'dart:core';
import 'package:leagify/models/result_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:leagify/mobile/game_details_post.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/player_stats.model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final Users userLogin;

  var imageData;


  Future<void> signOut(context) async {
    await APICacheManager().deleteCache("login_details");
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  String _logo(key) {
    String jsonString =
        '{"The Dudes": "assets/dudes.svg", "The Bokas": "assets/bokas.svg", "The Boros": "assets/theboros.svg", "The Goats": "assets/goats.svg"}';

    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    String value = jsonData.containsKey(key) ? jsonData[key] : "No Key";
    return value; // Output: "value2"
  }
  bool _isAdmin = false;



@override
  void initState() {
    // TODO: implement initState
  _loadImages();
    super.initState();
  }

  _loadImages() async {
  imageData = await SharedService.cachedPlayerImages();
  }


  @override
  Widget build(BuildContext buildContext) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      print('width: ' + constraints.maxWidth.toString());
      return Scaffold(
        backgroundColor: kCanvasColor,
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.2,
                  width: constraints.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome,",
                            style: kGreetingStyle,
                          ),
                          _userProfile(),
                        ],
                      ),padding: EdgeInsets.all(8),),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              SharedService.logout(context);
                            });
                          },
                          icon: Icon(Icons.logout))
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _matchList(constraints.maxWidth, constraints.maxHeight),
                SizedBox(
                  height: 40,
                ),

                Padding(padding: EdgeInsets.all(8),child: Text(
                  "Standings",
                  style: kLargeSubtitle.copyWith(color: kBrandColor),
                  textAlign: TextAlign.end,
                ),),
                Padding(padding: EdgeInsets.all(8),child: _standingTable(constraints.maxWidth, constraints.maxHeight),),
                Padding(padding: EdgeInsets.all(8),child: Text(
                  "Goals",
                  style: kLargeSubtitle.copyWith(color: kBrandColor),
                  textAlign: TextAlign.end,
                ),),
                Padding(padding: EdgeInsets.all(8),child: _goalsTable(constraints.maxWidth, constraints.maxHeight),),


              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _userProfile() {
    return FutureBuilder(
        future: SharedService.loginDetails(),
        builder:
            (BuildContext context, AsyncSnapshot<LoginResponseModel?> model) {
          if (model.hasData) {
            _isAdmin = model.data!.email == "kiran.silwal" ? true : false;
            return Text(
              model.data!.name + '!',
              style: kHeading(Color(0xFF3AA365)),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _matchList(double width, double height) {
    return FutureBuilder(
        future: APIService.getMatchCards(),
        builder: (BuildContext context, AsyncSnapshot<List<MatchList>> model) {
          if (model.hasData) {
            int completedGames =
                model.data!.where((element) => element.status == 1).length;
            return Container(
              height: height * 0.4,
              child: ListView.builder(
                controller: ScrollController(
                    initialScrollOffset: width * 0.8 * completedGames),
                scrollDirection: Axis.horizontal,
                itemCount: model.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return matchCards(model, index, width, height);
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget matchCards(AsyncSnapshot<List<MatchList>> model, int index,
      double width, double height) {
    DateTime Schedule = model.data![index].schedule!;
    String gameweek = model.data![index].gameweek.toString();
    String team1 = model.data![index].team1.toString();
    String team2 = model.data![index].team2.toString();
    String team1Score = model.data![index].team1Score.toString();
    String team2Score = model.data![index].team2Score.toString();
    int status = model.data![index].status!;
    bool hasScore = status == 1 ? true : false;
    List<Score?> score = model.data![index].scores!;
    Map<String, int> goalSum = {};


    return Container(
      width: width * 0.8,
      height: height * 0.4,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _team(team1, height, width),flex: 2,),
                      Expanded(
                        child: _score(Schedule, gameweek, team1Score, team2Score, status,
                            height,width),flex: 2,
                      ),
                      Expanded(child: _team(team2, height, width),flex: 2,),
                    ],
                  ),
                ),
                // Slider(
                //   value: status.toDouble(),
                //   max: 1,
                //   divisions: 1,
                //   activeColor: kBrandColor,
                //   inactiveColor: kScoreFutureMatch,
                //   onChanged: (double value) {
                //     setState(() {});
                //   },
                // ),
                Expanded(child: Divider(),flex: 1,),
                Expanded(
                  child: Container(
                    height: height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _playerScores(
                              score, hasScore, team1, TextAlign.start),
                        ),
                        status == 1 ? Icon(Icons.sports_soccer,color: kScoreFutureMatch,) : Container(height: 0,width: 0,),
                        Expanded(
                          flex: 2,
                          child: _playerScores(
                              score, hasScore, team2, TextAlign.end),
                        ),
                      ],
                    ),
                  ),flex: 10,
                ),
                Expanded(child: _isAdmin ? IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  UpdateMatch()));
                }, icon: Icon(Icons.edit,size: 15,)) : Container(),flex: 1,)
              ],
            ),
        ),
      ),
    );
  }

  Widget _team(String team, double height, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Image.network(
        //   _logo(team),
        //   height: height * 0.1,
        //   // width: width * 0.08,
        // ),
        Expanded(
          child: SvgPicture.asset(
          _logo(team),
          width: width * 0.15, fit: BoxFit.contain,
    ),flex: 2,
        ),
        // SizedBox(
        //   height: 20,
        // ),
        Expanded(
          child: Text(team,
              style: kNormalSize.copyWith(
                fontWeight: FontWeight.bold,
              )),flex: 1,
        ),
      ],
    );
  }

  Widget _score(DateTime scheduledTime, String gameweek, String team1Score,
      String team2Score, int status, double height, double width) {
    DateTime now = DateTime.now();
    Duration difference = scheduledTime.toLocal().difference(now);
    String dateString =
        DateFormat("EEE, MMM d").format(scheduledTime).toString();

    if (now.year == scheduledTime.year && now.month == scheduledTime.month && now.day == scheduledTime.day) {
      dateString = "Today";
    } else if (now.year == scheduledTime.year && now.month == scheduledTime.month && (now.day - scheduledTime.day) == 1) {
      dateString = "Yesterday";
    } else if (now.year == scheduledTime.year && now.month == scheduledTime.month && (now.day + scheduledTime.day) == 1) {
      dateString = "Tomorrow";
    }

    return Column(
      children: [
        Column(
          children: [
            Text(dateString, style: kLargeSubtitle),
            Text(
              gameweek,
              style: kSmallSubtitle.copyWith(color: kDescriptionStyle),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Container(
          width: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                team1Score == 'null' ? '0' : team1Score,
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch,fontSize: width * 0.07),
              ),
              Text(
                ":",
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch,fontSize: width * 0.07),
              ),
              Text(
                team2Score == 'null' ? '0' : team2Score,
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch,fontSize: width * 0.07),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _playerScores(List<Score?> matchPlayerScores, bool hasScore,
      String team, TextAlign align) {
    if (hasScore) {
      List<Score?> newScore = matchPlayerScores
          .where((e) => e!.team.toString() == team && e.statsType == "Goal")
          .toList();
      newScore.sort((a,b) => a!.statsTime!.compareTo(b!.statsTime!));
      print(newScore);
      return ListView.builder(
        itemCount: newScore.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Text(
            newScore[index]!.playerName! + " " + newScore[index]!.statsTime.toString()+ "'" ,
            textAlign: align,
            style: kSmallSubtitle.copyWith(fontSize: 12),
          );
        },
      );
    } else {
      return Text(
        "No Score",
        style: TextStyle(color: Color(0x00FFFFFF)),
      );
    }
  }

  Widget _standingTable(double width, double height) {
    return FutureBuilder(
        future: APIService.getStandings(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TeamStanding>> model) {
          if (model.hasData) {
            model.data!.sort((a, b) => b.points.compareTo(a.points));
            return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(padding: EdgeInsets.all(8.0),child: Column(
                children: [
                  _tableRow("Team","GP","W","D","L","Pts",width,true),
                  for (var items in model.data!) _tableRow(items.teamName.toString(),items.played.toString(),items.win.toString(),items.draw.toString(),items.loss.toString(),items.points.toString(),width,false),
                ],
              ),)
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _goalsTable(double width, double height) {
    return FutureBuilder(
        future: APIService.getGoals(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PlayerStats>> model) {
          print("inside goal");
          if (model.hasData) {
            model.data!.sort((a, b) => b.goal.compareTo(a.goal));
            return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(padding: EdgeInsets.all(8.0),child: Column(
                  children: [
                    _tableRowPlayers("Player","Goals","Assists","Yellow","Red",width,true),
                    for (var items in model.data!) _tableRowPlayers(items.name.toString(),items.goal.toString(),items.assists.toString(),items.yellow.toString(),items.red.toString(),width,false),
                  ],
                ),)
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }


  Widget _tableRow(String teamName,String played, String win, String draw, String loss, String points,double width, bool head){
    Color textColor = head ? kScoreFutureMatch : kScoreStyle;

   _getLogo(String teamName){
    return SvgPicture.asset(
      _logo(teamName),
      width: 40,
    );}
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4),child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _logo(teamName) == "No Key" ? Container(width: 40,) : _getLogo(teamName),flex:1),
            Expanded(child: Text(teamName,style: kNormalSize.copyWith(color: textColor),),flex:2),
            Expanded(child: Text(played.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
            Expanded(child:  Text(win.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
            Expanded(child: Text(draw.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
            Expanded(child: Text(loss.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
            Expanded(child: Text(points.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1)
          ],
        ),),
        Divider()
      ],
    );
  }
Widget _tableRowPlayers(String name,String goals, String assists, String yellow, String red,double width,bool head){
  Color textColor = head ? kScoreFutureMatch : kScoreStyle;
  Map<String,dynamic> newData = imageData;
  // print(newData['Sanish']);

_hasImage(name){
  if (newData.containsKey(name)){
    return 1;
  }else{
    return "No Key";
  }
}

   _getLogo(String teamName){
     print(newData[teamName]);
    return CircleAvatar(backgroundImage: CachedNetworkImageProvider(newData[teamName]),);
   }
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4),child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _hasImage(name) == "No Key" ? Container(width: 40,) : _getLogo(name),flex:1),
            SizedBox(width: 10,),
            Expanded(child: Text(name,style: kNormalSize.copyWith(color: textColor),),flex:2),
            Expanded(child: Text(goals.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
            Expanded(child:  Text(assists.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
            Expanded(child: Text(yellow.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
            Expanded(child: Text(red.toString(),style: kNormalSize.copyWith(color: textColor),),flex:1),
          ],
        ),),
        Divider()
      ],
    );
  }
  // }
}


