import 'dart:convert';

GameResponse gameResponseFromJson(String str) => GameResponse.fromJson(json.decode(str));

String gameResponseToJson(GameResponse data) => json.encode(data.toJson());

class GameResponse {
  GameResponse({
    required this.gameId,
    required this.team1Name,
    required this.team2Name,
    required this.team1Id,
    required this.team2Id,
  });

  int gameId;
  String team1Name;
  String team2Name;
  int team1Id;
  int team2Id;

  factory GameResponse.fromJson(Map<String, dynamic> json) => GameResponse(
    gameId: json["game_id"],
    team1Name: json["team_1_name"],
    team2Name: json["team_2_name"],
    team1Id: json["team_1_id"],
    team2Id: json["team_2_id"],
  );

  Map<String, dynamic> toJson() => {
    "game_id": gameId,
    "team_1_name": team1Name,
    "team_2_name": team2Name,
    "team_1_id": team1Id,
    "team_2_id": team2Id,
  };
}
