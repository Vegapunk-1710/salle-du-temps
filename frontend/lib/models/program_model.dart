class Program {
  String id;
  String createdBy;
  DateTime createdAt;
  String title;
  List<String> workouts;

  Program({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.title,
    required this.workouts,
  });

  static List<Program> db() {
    return [
      Program(id: "p1", createdBy: "Rony", title: "Rony's Program", workouts: ["w1","w3"], createdAt: DateTime.now()),
      Program(id: "p1", createdBy: "Rony", title: "Rony's Program", workouts: ["w1","w3"], createdAt: DateTime.now()),
      Program(id: "p1", createdBy: "Rony", title: "Rony's Program", workouts: ["w1","w3"], createdAt: DateTime.now()),
      Program(id: "p1", createdBy: "Rony", title: "Rony's Program", workouts: ["w1","w3"], createdAt: DateTime.now()),
      Program(id: "p1", createdBy: "Rony", title: "Rony's Program", workouts: ["w1","w3"], createdAt: DateTime.now()),
      Program(id: "p1", createdBy: "Rony", title: "Rony's Program", workouts: ["w1","w3"], createdAt: DateTime.now()),
      Program(id: "p1", createdBy: "Rony", title: "Rony's Program", workouts: ["w1","w3"], createdAt: DateTime.now()),
    ];
  }
}
