import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:leagify/mobile/Widgets/match_details.dart';
import 'package:leagify/models/login_response_model.dart';
import 'package:leagify/models/match_list.dart';
import 'package:leagify/services/api_service.dart';
import 'package:leagify/services/provider/data_provider.dart';
import 'package:leagify/services/shared_services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'dart:core';
import 'package:leagify/models/result_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:leagify/mobile/game_details_post.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leagify/mobile/Widgets/standing_table.dart';

import '../models/player_stats.model.dart';
import '../widescreen/wide_screen.dart';
import 'Widgets/stats_table.dart';
import 'Widgets/team_cards.dart';

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
        '{"The Dudes": "assets/dudes.png", "The Bokas": "assets/bokas.png", "The Boros": "assets/theboros.png", "The Goats": "assets/goats.png"}';

    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    String value = jsonData.containsKey(key) ? jsonData[key] : "No Key";
    return value; // Output: "value2"
  }

  bool _isAdmin = false;

  @override
  void initState() {
    // TODO: implement initState

    _loadData();
    final data = Provider.of<DataProvider>(context,listen: false);

    data.fetchMatchList(context);
    data.getCompletedGames(context);
    data.getStandingTable(context);
    data.getStats(context);
    data.getImageData(context);

    super.initState();
    APICacheDBModel(key: 'player_images', syncData: 'player_images');
  }

  _loadData() async {
    var data = await SharedService.cachedPlayerImages();

      imageData = data;

  }

  @override
  Widget build(BuildContext buildContext) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;
      if (width < 600){
        return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kCanvasColor,
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(

            clipBehavior: Clip.none,
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
                const Padding(
                  padding: const EdgeInsets.all(8),
                  // child: _standingTable(
                  //     constraints.maxWidth, constraints.maxHeight),
                  child: StandingTable(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Statistics",
                    style: kLargeSubtitle.copyWith(color: kBrandColor),
                    textAlign: TextAlign.end,
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.all(8),
                  // child:
                  //     _goalsTable(constraints.maxWidth, constraints.maxHeight),
                  child: StatsTable(),
                ),
              ],
            ),
          ),
        ),
      );} else {
        return WideLayout();
      }

    });
  }

  Widget _userProfile(double height) {
    return FutureBuilder(
        future: SharedService.loginDetails(),
        builder:
            (BuildContext context, AsyncSnapshot<LoginResponseModel?> model) {
          if (model.hasData) {
            _isAdmin = model.data!.isAdmin;
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
    final data = Provider.of<DataProvider>(context,listen: true);
    List<MatchList> games = data.matchList;

    return games.isEmpty ? Container() : SizedBox(
      height: height * 0.4,
      child: Consumer<DataProvider>(
        builder: (context,data,child) {
          int completedGames = data.completedGames;
          return ListView.builder(
            controller: ScrollController(
                initialScrollOffset: width * 0.8 * (completedGames - 1)),
            scrollDirection: Axis.horizontal,
            itemCount: data.matchList.length,
            itemBuilder: (BuildContext context, int index) {
              // return MatchCards(model: model.data!, index: index, isAdmin: _isAdmin,);
              return MatchCards(matchList: data.matchList[index],index: index,height: height,width: width,score: data.matchList[index].scores!,isAdmin: _isAdmin ,);
            },
          );
        }
      ),
    );
  }

  Widget matchCards(List<MatchList> model, int index,
      double width, double height) {
    int gameId = model[index].gameId!;
    DateTime schedule = model![index].schedule!;
    String gameweek = model[index].gameweek.toString();
    String team1 = model[index].team1.toString();
    String team2 = model[index].team2.toString();
    String team1Score = model[index].team1Score.toString();
    String team2Score = model[index].team2Score.toString();
    int status = model[index].status!;
    bool hasScore = status == 1 ? true : false;
    List<Score?> score = model[index].scores!;
    Map<String, int> goalSum = {};

    return InkWell(
      onLongPress: _isAdmin ? () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateMatch(gameId : gameId)));
      } : (){},
      onTap: (){Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  MatchDetails(matchId: gameId,)));},
      child: SizedBox(
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
                SizedBox(height: 10,)
              ],
            ),
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
          child: Image.asset(_logo(team),width: width * 0.2,),
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
            FittedBox(child: Text(dateString, style: kLargeSubtitle)),
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
}

