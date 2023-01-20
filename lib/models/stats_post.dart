class StatsPost {
  final int statstype;
  final int player;
  final int game;
  final int stats_time;

  StatsPost({
    required this.statstype,
    required this.player,
    required this.game,
    required this.stats_time
  });

  factory StatsPost.fromJson(Map<String, dynamic> json) {
    return StatsPost(
      statstype: json['statstype'],
      player: json['player'],
      game: json['game'],
      stats_time: json['stats_time'],
    );
  }

  Map<String, dynamic> toJson() => {
    'statstype': statstype,
    'player': player,
    'game': game,
    'stats_time': stats_time,
  };

}
