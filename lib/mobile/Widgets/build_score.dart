import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../constants.dart';

class BuildScore extends StatelessWidget {
  final DateTime scheduledTime;

  final String gameweek;

  final String team1Score;
  final String team2Score;

  final int status;

  const BuildScore({Key? key, required this.scheduledTime, required this.gameweek, required this.team1Score, required this.status, required this.team2Score}) : super(key: key);



  @override
  Widget build(BuildContext context) {
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
    return LayoutBuilder(
      builder: (context,constraints) {
        double height = constraints.maxHeight;
        double width = constraints.maxWidth;
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
    );
  }
}
