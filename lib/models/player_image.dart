class PlayerImage {
  final Map<String, dynamic> data;

  PlayerImage({required this.data});

  factory PlayerImage.fromJson(Map<String, dynamic> json) {
    return PlayerImage(data: json);
  }
}
