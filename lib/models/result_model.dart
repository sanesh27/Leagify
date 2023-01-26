class TeamStanding {
  final String teamName;
  final int loss;
  final int win;
  final int draw;
  final int points;
  final int played;
  final int goalsForward;
  final int goalsAgainst;
  final int goalDifference;
  final String logoURL;

  TeamStanding({required this.teamName, required this.win, required this.draw,required this.points,required this.logoURL,required this.loss,required this.played,required this.goalsForward, required this.goalsAgainst,required this.goalDifference});

  factory TeamStanding.fromJson(Map<String, dynamic> json) {


    return TeamStanding(
      teamName: json.keys.first,
      win: json.values.first['win'] ?? 0,
      draw: json.values.first['draw'] ?? 0,
      points: json.values.first['points'] ?? 0,
      logoURL: json.values.first['logoURL'],
      played: json.values.first['played'] ?? 0,
      goalsForward: json.values.first['GF'] ?? 0,
      goalsAgainst: json.values.first['GA'] ?? 0,
      goalDifference: json.values.first['GD'] ?? 0,
      loss : json.values.first['loss'] ?? 0,
    );
  }
}
