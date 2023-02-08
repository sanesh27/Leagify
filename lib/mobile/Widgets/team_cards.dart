import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leagify/constants.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../models/match_list.dart';
import '../game_details_post.dart';

class MatchCards extends StatelessWidget {
  const MatchCards({Key? key, required this.matchList, required this.index, required this.height, required this.width, required this.score, required this.isAdmin}) : super(key: key);
  final MatchList matchList;
  final int index;
  final double height;
  final double width;
  final List<Score?> score;
  final bool isAdmin;

  String _logo(key) {
    String jsonString =
        '{"The Dudes": "assets/dudes.png", "The Bokas": "assets/bokas.png", "The Boros": "assets/theboros.png", "The Goats": "assets/goats.png"}';

    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    String value = jsonData.containsKey(key) ? jsonData[key] : "No Key";
    return value; // Output: "value2"
  }



  String getDateString(DateTime scheduledTime){
    DateTime now = DateTime.now();
    String dateString = DateFormat("EEE, MMM d").format(scheduledTime).toString();

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
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(isAdmin.toString());
    bool hasScore = matchList.status == 1 ? true : false;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: width * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              clipBehavior: Clip.none,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(getDateString(matchList.schedule!),style: kLargeSubtitle,),
                          Text(matchList.gameweek!,style: kSmallSubtitle,),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex:3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RepaintBoundary(
                          child: Image.asset(

                            _logo(matchList.team1),
                            width: width * 0.20,
                            fit: BoxFit.contain,
                          ),
                        ),
                        matchList.status == 1 ? Text(matchList.team1Score.toString(),style: kLargeSubtitle,):Text("0",style: kLargeSubtitle.copyWith(color: kScoreFutureMatch),),
                        Text(":",style: kLargeSubtitle,),
                        matchList.status == 1 ? Text(matchList.team2Score.toString(),style: kLargeSubtitle,):Text("0",style: kLargeSubtitle.copyWith(color: kScoreFutureMatch),),
                        RepaintBoundary(
                          child: Image.asset(

                            _logo(matchList.team2),
                            width: width * 0.20,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 1,child: ScoreView(matchList: matchList, team: matchList.team1!,align: TextAlign.left,)),
                        isAdmin ? IconButton(onPressed: (){Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateMatch(gameId : matchList.gameId!)));}, icon: const Icon(Icons.edit),color: kScoreStyle,) : Icon(Icons.sports_soccer_sharp,color: kScoreStyle,),
                        Expanded(flex: 1,child: ScoreView(matchList: matchList, team: matchList.team2!,align: TextAlign.right,)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );

  }
}

class ScoreView extends StatelessWidget {
   const ScoreView({
    Key? key,
    required this.matchList, required this.team, required this.align,
  }) : super(key: key);

  final MatchList matchList;
  final String team;
  final TextAlign align;


  @override
  Widget build(BuildContext context) {
    List<Score?> newScore = matchList.scores!.where((e) => e!.team.toString() == team && e.statsType == "Goal")
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: newScore.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Text(
            "${newScore[index]!.playerName!} ${newScore[index]!.statsTime}'",
            textAlign: align,
            style: kSmallSubtitle.copyWith(fontSize: 12),
          );
        },
      ),
    );
  }
}
