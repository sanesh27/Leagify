import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leagify/constants.dart';
import 'package:leagify/models/player_stats.model.dart';
import 'package:provider/provider.dart';

import '../../services/provider/data_provider.dart';

class StatsTable extends StatelessWidget {
  const StatsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context,listen: true);
    return data.statistics.isEmpty ? Container() : Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlayerStatsTable(data: data),
      ),
    );
  }
}

class PlayerStatsTable extends StatelessWidget {
  const PlayerStatsTable({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DataProvider data;

  @override
  Widget build(BuildContext context) {
    debugPrint("StatsTable");
    List<PlayerStats> goalStats = data.goalStats;
    goalStats.sort((a, b) => b.goal.compareTo(b.goal));

    return Consumer<DataProvider>(
      builder: (context,data,child) {
        debugPrint(data.goalStats[4].goal.toString());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Goals",style: kLargeSubtitle.copyWith(color: kBrandColor),),
            for (PlayerStats item in goalStats) goalStats.isEmpty ? Container() : Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlayerStatsRow(name: item.name,goal: item.goal),
            ),
            Text("Assists",style: kLargeSubtitle.copyWith(color: kBrandColor),),
            for (PlayerStats item in data.assistStats) Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlayerStatsRow(name: item.name,goal: item.assists),
            ),

            Text("Yellow",style: kLargeSubtitle.copyWith(color: kBrandColor),),
            for (PlayerStats item in data.yellowStats) Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlayerStatsRow(name: item.name,goal: item.yellow),
            ),
            Text("Red",style: kLargeSubtitle.copyWith(color: kBrandColor),),
            for (PlayerStats item in data.redStats) Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlayerStatsRow(name: item.name,goal: item.red),
            ),
          ],
        );
      }
    );
  }
}

class PlayerStatsRow extends StatelessWidget {
  const PlayerStatsRow({
    Key? key,
    required this.name, required this.goal,
  }) : super(key: key);

  final String name;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context,listen: false);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                data.imageData[name] == null ? Container() : RepaintBoundary(child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(data.imageData[name],),)),
                const SizedBox(width: 20,),
                Text(name,style: kLargeSubtitle.copyWith(color: kScoreStyle),)
              ],
            ),
            Text(goal.toString(),style: kLargeSubtitle.copyWith(color: kScoreStyle),)
          ],
        ),
        const Divider(),
      ],
    );
  }
}
