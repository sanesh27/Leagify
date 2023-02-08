import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leagify/constants.dart';
import 'package:leagify/models/result_model.dart';
import 'package:provider/provider.dart';

import '../../services/provider/data_provider.dart';

class StandingTable extends StatelessWidget {
  const StandingTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Built StandingTable");
    final data = Provider.of<DataProvider>(context,listen: true);
    return  data.standings.isEmpty ? const Text("Fetching table") : Card(
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context,constraints) {
          double width = constraints.maxWidth;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                  for (TeamStanding teamStanding in data.standings) TableRow(teamStanding: teamStanding)
              ],
            ),
          );
        }
      ),
    );
  }
}

class TableRow extends StatelessWidget {
   TableRow({
    Key? key,
    required this.teamStanding,
  }) : super(key: key);
  String jsonString =
      '{"The Dudes": "assets/dudes.svg", "The Bokas": "assets/bokas.svg", "The Boros": "assets/theboros.svg", "The Goats": "assets/goats.svg"}';

  final TeamStanding teamStanding;

  String _logo(key) {


    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    String value = jsonData.containsKey(key) ? jsonData[key] : "No Key";
    return value; // Output: "value2"
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Built TableRow");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _logo(teamStanding.teamName) == "No Key" ? Container(width: 40,) : SvgPicture.asset(_logo(teamStanding.teamName),clipBehavior: Clip.none,width: 40),
            Text(teamStanding.teamName,style: kNormalSize.copyWith(color: kScoreStyle),),
            Text(teamStanding.played.toString(),style: kNormalSize.copyWith(color: kScoreStyle),),
            Text(teamStanding.win.toString(),style: kNormalSize.copyWith(color: kScoreStyle),),
            Text(teamStanding.loss.toString(),style: kNormalSize.copyWith(color: kScoreStyle),),
            Text(teamStanding.draw.toString(),style: kNormalSize.copyWith(color: kScoreStyle),),
            Text(teamStanding.goalDifference.toString(),style: kNormalSize.copyWith(color: kScoreStyle),),
            Text(teamStanding.points.toString(),style: kNormalSize.copyWith(color: kScoreStyle),),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
