import 'package:flutter/material.dart';
import 'package:leagify/models/player_stats.model.dart';
import 'package:leagify/models/result_model.dart';
import 'package:leagify/services/api_service.dart';
import 'package:leagify/services/shared_services.dart';

import '../../models/match_list.dart';

class DataProvider extends ChangeNotifier{
  int completedGames = 0;
   List<MatchList> matchList = [];
   List<TeamStanding> standings = [];
   List<PlayerStats> statistics = [];
   List<PlayerStats> goalStats = [];
   List<PlayerStats> assistStats = [];
   List<PlayerStats> yellowStats = [];
   List<PlayerStats> redStats = [];
  Map<String, dynamic> imageData = {};
  fetchMatchList(context) async {
      matchList = await APIService.getMatchCards();
      completedGames = matchList.where((element) => element!.schedule!.isBefore(DateTime.now())).length;
      if (completedGames > 0 ) {

        notifyListeners();
      }
  }
  getCompletedGames(context){

  }

  getStandingTable(context) async {
    standings = await APIService.getStandings();
    standings!.sort((a, b) {
      if (a.points == b.points) {
        return b.goalDifference.compareTo(a.goalDifference);
      }
      return b.points.compareTo(a.points);
    });
    // notifyListeners();
  }

  getStats(context) async {
    statistics = await APIService.getGoals();
    goalStats = statistics.where((element) => element.goal > 0).toList(growable: false)..sort((a, b) => b.goal.compareTo(a.goal));
    assistStats = statistics.where((element) => element.assists > 0).toList(growable: false)..sort((a, b) => b.assists.compareTo(a.assists));
    yellowStats = statistics.where((element) => element.yellow > 0).toList(growable: false)..sort((a, b) => b.yellow.compareTo(a.yellow));
    redStats = statistics.where((element) => element.red > 0).toList(growable: false)..sort((a, b) => b.red.compareTo(a.red));
    notifyListeners();
  }

  getImageData(context) async {
    imageData = await SharedService.cachedPlayerImages();
    notifyListeners();
  }
}