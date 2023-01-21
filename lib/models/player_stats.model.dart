class PlayerStats {
  final String name;
  final int goal;
  final int assists;
  final int yellow;
  final int red;
  final String team;

  PlayerStats({required this.name, required this.goal, required this.assists, required this.yellow, required this.red,required this.team});

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      name: json['name'],
      goal: json['goal'],
      assists: json['assists'],
      yellow: json['yellow'],
      red: json['red'],
      team: json['team']
    );
  }
}