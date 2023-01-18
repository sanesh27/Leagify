// To parse this JSON data, do
//
//     final matchList = matchListFromJson(jsonString);

import 'dart:convert';

MatchList? matchListFromJson(String str) => MatchList.fromJson(json.decode(str));

String matchListToJson(MatchList? data) => json.encode(data!.toJson());

class MatchList {
  MatchList({
    this.gameId,
    this.gameweek,
    this.schedule,
    this.status,
    this.team1,
    this.team2,
    this.league,
    this.team1Score,
    this.team2Score,
    this.scores,
  });

  int? gameId;
  String? gameweek;
  DateTime? schedule;
  int? status;
  String? team1;
  String? team2;
  String? league;
  int? team1Score;
  int? team2Score;
  List<Score?>? scores;

  factory MatchList.fromJson(Map<String, dynamic> json) {
    return MatchList(
      gameId: json["game_id"],
      gameweek: json["gameweek"],
      schedule: DateTime.parse(json["schedule"]),
      status: json["status"],
      team1: json["team_1"],
      team2: json["team_2"],
      league: json["league"],
      team1Score: json["team_1_score"],
      team2Score: json["team_2_score"],
      scores: json["scores"] == null
          ? []
          : List<Score?>.from(json["scores"]!.map((x) => Score.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "game_id": gameId,
    "gameweek": gameweek,
    "schedule": schedule?.toIso8601String(),
    "status": status,
    "team_1": team1,
    "team_2": team2,
    "league": league,
    "team_1_score": team1Score,
    "team_2_score": team2Score,
    "scores": scores == null ? [] : List<dynamic>.from(scores!.map((x) => x!.toJson())),
  };
}

class Score {
  Score({
    this.playerName,
    this.team,
    this.statsType,
    this.statsTime,
  });

  String? playerName;
  String? team;
  String? statsType;
  int? statsTime;

  factory Score.fromJson(Map<String, dynamic> json) {


    return Score(
      playerName: json["player_name"],
      team: json["team"],
      statsType: json["stats_type"],
      statsTime : json["stats_time"]
    );
  }

  Map<String, dynamic> toJson() => {
    "player_name": playerName ?? "Not updated",
    "team": team ?? "Not updated",
    "stats_type": statsType ?? "Not updated",
    "stats_time": statsType ?? "Not updated",

  };
}
