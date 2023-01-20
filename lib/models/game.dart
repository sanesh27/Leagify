class Game {
  int id;
  int status;
  int winner;
  int firstTeamScore;
  int secondTeamScore;

  Game({
    required this.id,
    required this.status,
    required this.winner,
    required this.firstTeamScore,
    required this.secondTeamScore,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      status: json['status'] ?? 0,
      winner: json['winner'] ?? 0,
      firstTeamScore: json['first_team_score'] ?? 0,
      secondTeamScore: json['second_team_score'] ?? 0,
    );
  }
}
