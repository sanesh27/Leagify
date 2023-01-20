class Team {
  final int id;
  final String name;
  final String photo;

  Team({
    required this.id,
    required this.name,
    required this.photo
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}
