import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final Users userLogin;
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
  Widget build(BuildContext buildContext) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      return Scaffold(
        backgroundColor: kCanvasColor,
        body: Padding(
          padding: const EdgeInsets.all(0),
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
                height: 24,
              ),
              Padding(padding: EdgeInsets.all(8),child: Text(
                "Standings",
                style: kLargeSubtitle.copyWith(color: kBrandColor),
                textAlign: TextAlign.start,
              ),),
              Padding(padding: EdgeInsets.all(8),child: _standingTable(constraints.maxWidth, constraints.maxHeight),),

            ],
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
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _team(team1, height, width),
                      _score(Schedule, gameweek, team1Score, team2Score, status,
                          height),
                      _team(team2, height, width),
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
                Divider(),
                Container(
                  height: height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _playerScores(
                            score, hasScore, team1, TextAlign.start),
                      ),
                      Expanded(
                        flex: 1,
                        child: _playerScores(
                            score, hasScore, team2, TextAlign.end),
                      ),

                      _isAdmin ? IconButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  UpdateMatch()));
                      }, icon: Icon(Icons.edit)) : Container(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _team(String team, double height, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.network(
        //   _logo(team),
        //   height: height * 0.1,
        //   // width: width * 0.08,
        // ),
        SvgPicture.asset(
        _logo(team),
        width: width * 0.15,
    ),
        SizedBox(
          height: 20,
        ),
        Text(team,
            style: kNormalSize.copyWith(
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget _score(DateTime scheduledTime, String gameweek, String team1Score,
      String team2Score, int status, height) {
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
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch),
              ),
              Text(
                ":",
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch),
              ),
              Text(
                team2Score == 'null' ? '0' : team2Score,
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch),
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
      print(newScore);
      return ListView.builder(
        itemCount: newScore.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Text(
            newScore[index]!.playerName!,
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
                  _tableRow("Team","GP","W","D","L","Pts",width),
                  for (var items in model.data!) _tableRow(items.teamName.toString(),items.played.toString(),items.win.toString(),items.draw.toString(),items.loss.toString(),items.points.toString(),width),
                ],
              ),)
            );
            // return Card(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(16)),
            //   elevation: 1,
            //   child: Container(
            //       height: height * 0.2,
            //       child: Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Table(
            //           children: [
            //             TableRow(
            //               children: [
            //                 Text(
            //                   'Team',
            //                   style: kNormalSize.copyWith(
            //                       color: kScoreFutureMatch),
            //                 ),
            //                 Text('MP',
            //                     style: kNormalSize.copyWith(
            //                         color: kScoreFutureMatch)),
            //                 Text('Win',
            //                     style: kNormalSize.copyWith(
            //                         color: kScoreFutureMatch)),
            //                 Text('Draw',
            //                     style: kNormalSize.copyWith(
            //                         color: kScoreFutureMatch)),
            //                 Text('Points',
            //                     style: kNormalSize.copyWith(
            //                         color: kScoreFutureMatch)),
            //               ],
            //             ),
            //             for (var i = 0; i < model.data!.length; i++)
            //               TableRow(
            //                 decoration: BoxDecoration(
            //                     color:
            //                         i.isEven ? kScoreFutureMatch : Colors.white,
            //                     shape: BoxShape.rectangle),
            //                 children: [
            //                   Text(
            //                     model.data![i].teamName,
            //                     style: kNormalSize,
            //                   ),
            //                   Text(
            //                     (model.data![i].played )
            //                         .toString(),
            //                     style: kNormalSize,
            //                   ),
            //                   Text(model.data![i].win.toString(),
            //                       style: kNormalSize),
            //                   Text(model.data![i].draw.toString(),
            //                       style: kNormalSize),
            //                   Text(model.data![i].points.toString(),
            //                       style: kNormalSize),
            //                 ],
            //               ),
            //           ],
            //         ),
            //       )),
            // );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }


  Widget _tableRow(String teamName,String played, String win, String draw, String loss, String points,double width){

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
            Expanded(child: Text(teamName,style: kNormalSize,),flex:2),
            Expanded(child: Text(played.toString(),style: kNormalSize,),flex:1),
            Expanded(child:  Text(win.toString(),style: kNormalSize,),flex:1),
            Expanded(child: Text(draw.toString(),style: kNormalSize,),flex:1),
            Expanded(child: Text(loss.toString(),style: kNormalSize,),flex:1),
            Expanded(child: Text(points.toString(),style: kNormalSize,),flex:1)
          ],
        ),),
        Divider()
      ],
    );
  }
  // }
}

// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: <Widget>[
// Container(
// height: height*0.2,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Container(
// height : 100,
// width: 100,
// child: Image.network('https://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Liverpool_FC.svg/1200px-Liverpool_FC.svg.png',)),
// Text(team1,style: kNormalSize.copyWith(fontWeight: FontWeight.bold,)),
// ],
// ),
// Column(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Text(Schedule,style: kNormalSize.copyWith(fontWeight: FontWeight.bold, ),),
// Text(gameweek,style: kSmallSubtitle.copyWith(color: kDescriptionStyle),),
// Row(
// children: [
// Text(team1Score == 'null'?'0':team1Score,style: kLargeSubtitle,),
// Text(":",style: kLargeSubtitle,),
// Text(team2Score == 'null'?'0':team2Score,style: kLargeSubtitle,),
// ],
// ),
//
// ],
// ),
// Text(team2,style: kNormalSize.copyWith(fontWeight: FontWeight.bold,)),
// ],
// ),
// ),
//
// ],
// )
