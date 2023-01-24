import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/match_list.dart';

class PlayerScore extends StatelessWidget {
  final bool hasScore;

  final List<Score?> matchPlayerScores;
  final String team;
  final TextAlign align;

  const PlayerScore({Key? key, required this.hasScore,required this.matchPlayerScores,required this.team, required this.align}) : super(key: key);


  @override
  Widget build(BuildContext context) {
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
