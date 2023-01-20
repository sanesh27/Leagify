class Position {
  final int id;
  final String positiontype;

  Position({
    required this.id,
    required this.positiontype
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'],
      positiontype: json['positiontype'] ?? '',
    );
  }
}
