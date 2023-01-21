import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:leagify/models/login_response_model.dart';
import 'package:leagify/models/match_list.dart';
import 'package:leagify/services/api_service.dart';
import 'package:leagify/services/shared_services.dart';

import '../constants.dart';
import 'dart:core';
import 'package:leagify/models/result_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:leagify/mobile/game_details_post.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/player_stats.model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

    _loadData();

    super.initState();
    APICacheDBModel(key: 'player_images', syncData: 'player_images');
  }

  _loadData() async {
    var data = await SharedService.cachedPlayerImages();
    setState(() {
      imageData = data;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      return Scaffold(
        backgroundColor: kCanvasColor,
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                  height: height * 0.05,
                ),
                SizedBox(
                  height: height * 0.1,
                  width: constraints.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome,",
                              style: kGreetingStyle,
                            ),
                            _userProfile(height),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              SharedService.logout(context);
                            });
                          },
                          icon: const Icon(Icons.logout))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                _matchList(constraints.maxWidth, constraints.maxHeight),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Standings",
                    style: kLargeSubtitle.copyWith(color: kBrandColor),
                    textAlign: TextAlign.end,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _standingTable(
                      constraints.maxWidth, constraints.maxHeight),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Statistics",
                    style: kLargeSubtitle.copyWith(color: kBrandColor),
                    textAlign: TextAlign.end,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child:
                      _goalsTable(constraints.maxWidth, constraints.maxHeight),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _userProfile(double height) {
    return FutureBuilder(
        future: SharedService.loginDetails(),
        builder:
            (BuildContext context, AsyncSnapshot<LoginResponseModel?> model) {
          if (model.hasData) {
            _isAdmin = model.data!.email == "kiran.silwal" || model.data!.email == "niraj.shrestha" || model.data!.email == "samin.maharjan" || model.data!.email == "sanish.maharjan"  ? true : false;
            return Text(
              '${model.data!.name}!',
              style: kHeading(const Color(0xFF3AA365), height),
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
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
            return SizedBox(
              height: height * 0.4,
              child: ListView.builder(
                controller: ScrollController(
                    initialScrollOffset: width * 0.8 * (completedGames - 1)),
                scrollDirection: Axis.horizontal,
                itemCount: model.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return matchCards(model, index, width, height);
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget matchCards(AsyncSnapshot<List<MatchList>> model, int index,
      double width, double height) {
    int gameId = model.data![index].gameId!;
    DateTime schedule = model.data![index].schedule!;
    String gameweek = model.data![index].gameweek.toString();
    String team1 = model.data![index].team1.toString();
    String team2 = model.data![index].team2.toString();
    String team1Score = model.data![index].team1Score.toString();
    String team2Score = model.data![index].team2Score.toString();
    int status = model.data![index].status!;
    bool hasScore = status == 1 ? true : false;
    List<Score?> score = model.data![index].scores!;
    Map<String, int> goalSum = {};

    return SizedBox(
      width: width * 0.8,
      height: height * 0.4,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _team(team1, height, width),
                    ),
                    Expanded(
                      flex: 2,
                      child: _score(schedule, gameweek, team1Score, team2Score,
                          status, height, width),
                    ),
                    Expanded(
                      flex: 2,
                      child: _team(team2, height, width),
                    ),
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: Divider(),
              ),
              Expanded(
                flex: 10,
                child: SizedBox(
                  height: height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _playerScores(
                            score, hasScore, team1, TextAlign.start),
                      ),
                      status == 1
                          ? Icon(
                              Icons.sports_soccer,
                              color: kScoreFutureMatch,
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      Expanded(
                        flex: 2,
                        child: _playerScores(
                            score, hasScore, team2, TextAlign.end),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: _isAdmin
                    ? IconButton(
                  color: kBrandColor,
                        alignment: Alignment.topCenter,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateMatch(gameId : gameId)));
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        ))
                    : Container(),
              ),
              SizedBox(height: 10,)
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
          flex: 2,
          child: SvgPicture.asset(
            _logo(team),
            width: width * 0.20,
            fit: BoxFit.contain,
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        // Expanded(
        //   flex: 1,
        //   child: Text(team,
        //       style: kNormalSize.copyWith(
        //         fontWeight: FontWeight.bold,
        //       )),
        // ),
      ],
    );
  }

  Widget _score(DateTime scheduledTime, String gameweek, String team1Score,
      String team2Score, int status, double height, double width) {
    DateTime now = DateTime.now();
    String dateString =
        DateFormat("EEE, MMM d").format(scheduledTime).toString();

    if (now.year == scheduledTime.year &&
        now.month == scheduledTime.month &&
        now.day == scheduledTime.day) {
      dateString = "Today";
    } else if (now.year == scheduledTime.year &&
        now.month == scheduledTime.month &&
        (now.day - scheduledTime.day) == 1) {
      dateString = "Yesterday";
    } else if (now.year == scheduledTime.year &&
        now.month == scheduledTime.month &&
        (scheduledTime.day - now.day) == 1) {
      dateString = "Tomorrow";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        SizedBox(
          width: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                team1Score == 'null' ? '0' : team1Score,
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch,
                    fontSize: width * 0.07),
              ),
              Text(
                ":",
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch,
                    fontSize: width * 0.07),
              ),
              Text(
                team2Score == 'null' ? '0' : team2Score,
                style: kLargeSubtitle.copyWith(
                    color: status == 1 ? kScoreStyle : kScoreFutureMatch,
                    fontSize: width * 0.07),
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
      newScore.sort((a, b) => a!.statsTime!.compareTo(b!.statsTime!));
      return ListView.builder(
        itemCount: newScore.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Text(
            "${newScore[index]!.playerName!} ${newScore[index]!.statsTime}'",
            textAlign: align,
            style: kSmallSubtitle.copyWith(fontSize: 12),
          );
        },
      );
    } else {
      return const Text(
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _tableRow(
                          "Team", "GP", "W", "D", "L", "Pts", width, true),
                      for (var items in model.data!)
                        _tableRow(
                            items.teamName.toString(),
                            items.played.toString(),
                            items.win.toString(),
                            items.draw.toString(),
                            items.loss.toString(),
                            items.points.toString(),
                            width,
                            false),
                    ],
                  ),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _goalsTable(double width, double height) {
    return FutureBuilder(
        future: APIService.getGoals(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PlayerStats>> statsModel) {
          if (statsModel.hasData) {
            List<PlayerStats> goalsSort = statsModel.data!;
            List<PlayerStats> assistSort = [];
            for (var element in goalsSort) {
              assistSort.add(element);
            }
            goalsSort.sort((a, b) => b.goal.compareTo(a.goal));
            assistSort.sort((a, b) => b.assists.compareTo(a.assists));

            return Column(
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "Goals",
                              style:
                                  kLargeSubtitle.copyWith(color: kBrandColor),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          _tableRowPlayers("Player", "Goals", width, true,"None"),
                          for (var items
                              in goalsSort.where((element) => element.goal > 0))
                            _tableRowPlayers(items.name.toString(),
                                items.goal.toString(), width, false,items.team),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "Assists",
                              style:
                                  kLargeSubtitle.copyWith(color: kBrandColor),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          _tableRowPlayers("Player", "Assists", width, true,"None"),
                          for (var items in assistSort
                              .where((element) => element.assists > 0))
                            _tableRowPlayers(
                                items.name.toString(),
                                items.assists.toString().toString(),
                                width,
                                false,items.team),
                        ],
                      ),
                    )),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _tableRow(String teamName, String played, String win, String draw,
      String loss, String points, double width, bool head) {
    Color textColor = head ? kScoreFutureMatch : kScoreStyle;

    getLogo(String teamName) {
      return SvgPicture.asset(
        _logo(teamName),
        width: 40,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: _logo(teamName) == "No Key"
                      ? Container(
                          width: 40,
                        )
                      : getLogo(teamName)),
              Expanded(
                  flex: 2,
                  child: Text(
                    teamName,
                    style: kNormalSize.copyWith(color: textColor),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    played.toString(),
                    style: kNormalSize.copyWith(color: textColor),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    win.toString(),
                    style: kNormalSize.copyWith(color: textColor),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    draw.toString(),
                    style: kNormalSize.copyWith(color: textColor),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    loss.toString(),
                    style: kNormalSize.copyWith(color: textColor),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    points.toString(),
                    style: kNormalSize.copyWith(color: textColor),
                  ))
            ],
          ),
        ),
        const Divider()
      ],
    );
  }

  Widget _tableRowPlayers(String name, String goals, double width, bool head,String team) {
    Color textColor = head ? kScoreFutureMatch : kScoreStyle;

    Map<String, dynamic> newData = imageData;
    // print(newData['Sanish']);

    hasImage(name) {
      if (newData.containsKey(name)) {
        return 1;
      } else {
        return "No Key";
      }
    }

    getLogo(String teamName,String team) {
      return Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(newData[teamName]),
            radius: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(teamName, style: kLargeSubtitle.copyWith(color: textColor)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SvgPicture.asset(
                    _logo(team),
                    width: 25,
                    fit: BoxFit.contain,

                  ),
                  SizedBox(width: 10,),
                  Text(team, style: kNormalSize.copyWith(fontSize: 12.0,color: kGreetingColor)),
                ],
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child: hasImage(name) == "No Key"
                      ? Container(
                          width: 0,
                        )
                      : getLogo(name,team)),
              Expanded(
                  flex: 1,
                  child: Text(
                    goals.toString(),
                    style: kLargeSubtitle.copyWith(color: textColor),
                  )),
            ],
          ),
        ),
        const Divider()
      ],
    );
  }
  // }
}
