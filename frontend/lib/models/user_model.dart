class User {
  String id;
  String username;
  String password;
  String name;
  String dob;
  DateTime createdAt;
  DateTime updatedAt;
  num startingWeight;
  int height;
  List<String> workouts;
  List<(DateTime date, List<String> imagesPaths, String weight)> progression;

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
      required this.workouts,
      required this.progression});

  @override
  String toString() {
    return "id : $id\nusername : $username \npassword : $password\nname : $name\ndob : $dob\ncreatedAt : $createdAt\nupdatedAt: $updatedAt\nstartingWeight: $startingWeight\nworkouts : $workouts\nprogression : $progression";
  }
}
