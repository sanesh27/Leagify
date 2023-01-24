import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leagify/mobile/Widgets/player_score.dart';
import 'package:leagify/models/match_list.dart';

import '../../constants.dart';
import '../game_details_post.dart';
import 'package:leagify/mobile/Widgets/build_score.dart';




class MatchCards extends StatelessWidget {
  const MatchCards({Key? key, required this.model, required this.index,required this.isAdmin}) : super(key: key);
  final List<MatchList> model;
  final int index;
  final bool isAdmin;

  String _logo(key) {
    String jsonString =
        '{"The Dudes": "assets/dudes.svg", "The Bokas": "assets/bokas.svg", "The Boros": "assets/theboros.svg", "The Goats": "assets/goats.svg"}';

    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    String value = jsonData.containsKey(key) ? jsonData[key] : "No Key";
    return value; // Output: "value2"
  }

  @override
  Widget build(BuildContext context) {
    int gameId = model[index].gameId!;
    DateTime schedule = model[index].schedule!;
    String gameweek = model[index].gameweek.toString();
    String team1 = model[index].team1.toString();
    String team2 = model[index].team2.toString();
    String team1Score = model[index].team1Score.toString();
    String team2Score = model[index].team2Score.toString();
    int status = model[index].status!;
    bool hasScore = status == 1 ? true : false;
    List<Score?> score = model[index].scores!;
    Map<String, int> goalSum = {};

    return LayoutBuilder(
      builder: (context,constraints) {
        double height = constraints.maxHeight;
        double width = constraints.maxWidth;
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SvgPicture.asset(
                                  _logo(team1),
                                  width: width * 0.20,
                                  fit: BoxFit.contain,
                                ),
                              ),

                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: BuildScore(gameweek: gameweek,scheduledTime: schedule,status: status,team1Score: team1Score,team2Score: team2Score,),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SvgPicture.asset(
                                  _logo(team2),
                                  width: width * 0.20,
                                  fit: BoxFit.contain,
                                ),
                              ),

                            ],
                          ),
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
                            child: PlayerScore(hasScore: hasScore, matchPlayerScores: score, team: team1, align: TextAlign.start)
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
                            child: PlayerScore(hasScore: hasScore, matchPlayerScores: score, team: team2, align: TextAlign.end)
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: isAdmin
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
    );
  }
}
