import 'package:leagify/models/teams.dart';
import 'package:leagify/models/position.dart';

class Player {
  final int id;
  final String fname;
  final int? team;
  final String? photo;
  final int? position;
  final String lname;
  final String email;

  Player({
    required this.id,
    required this.fname,
    required this.team,
    this.photo,
    required this.position,
    required this.lname,
    required this.email
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    // print(json['id']);
    // print(json['fname']);
    // print(json['team']);
    // print(json['photo']);
    // print(json['position']);
    // print(json['lname']);
    // print(json['email']);
    return Player(
      id: json['id'],
      fname: json['fname'] ?? '',
      team: json['team'] ?? 0,
      photo: json['photo'] ?? '',
      position: json['position'] ?? 0,
      lname: json['lname'] ?? '',
      email: json['email'] ?? '',
    );
  }
}


