class StatsType {
  final int id;
  final String statsname;

  StatsType({
    required this.id,
    required this.statsname
  });

  factory StatsType.fromJson(Map<String, dynamic> json) {
    return StatsType(
      id: json['id'],
      statsname: json['statsname'] ?? '',
    );
  }
}
