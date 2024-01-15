import 'dart:convert';
import 'package:frontend/models/workout_model.dart';

class User {
  late String id;
  late String username;
  late String password;
  late String name;
  late DateTime dob;
  late DateTime createdAt;
  late DateTime updatedAt;
  late num startingWeight;
  late int height;
  late List<Workout> workouts;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.name,
      required this.dob,
      required this.createdAt,
      required this.updatedAt,
      required this.startingWeight,
      required this.height,
      required this.workouts});

  @override
  String toString() {
    return "id : $id\nusername : $username \npassword : $password\nname : $name\ndob : $dob\ncreatedAt : $createdAt\nupdatedAt: $updatedAt\nstartingWeight: $startingWeight\nworkouts : $workouts\n";
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    dob = DateTime.parse(json['dob']);
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    startingWeight = json['startingWeight'];
    height = json['height'];
    workouts = json['workouts'].map<Workout>((w) => Workout.fromJson(w)).toList();
  }
}
