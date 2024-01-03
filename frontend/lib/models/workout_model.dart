class Workout {
  String id;
  String imageURL;
  String createdBy;
  DateTime createdAt;
  String title;
  Difficulty difficulty;
  int time;
  String description;
  List<String> exercises;
  List<Days> days;
  List<(DateTime date, String time)> progression;

  Workout({
    required this.id,
    required this.imageURL,
    required this.createdBy,
    required this.createdAt,
    required this.title,
    required this.difficulty,
    required this.time,
    required this.description,
    required this.exercises,
    required this.days,
    required this.progression
  });

  @override
  String toString() {
    return "id : $id\nimageURL : $imageURL \ntitle : $title\ndifficulty : $difficulty\ntime : $time\ndescription : $description\nfrequency : $days\exercises : $exercises\n";
  }

  static Days translateStringToDay(String name) {
    for (Days d in Days.values) {
      if (name == d.name) {
        return d;
      }
    }
    return Days.Monday;
  }

  static Difficulty translateStringToDifficulty(String name) {
    for (Difficulty d in Difficulty.values) {
      if (name == d.name) {
        return d;
      }
    }
    return Difficulty.Beginner;
  }

  static List<Workout> db() {
    return [
      Workout(
        id: 'w1',
        imageURL: "",
        // imageURL: "https://www.bodybuilding.com/images/2020/february/generic-training-inset-1-700xh.jpg",
        createdBy: "Rony",
        createdAt: DateTime.now(),
        title: 'Full Body Strength',
        difficulty: Difficulty.Advanced,
        time: 60,
        description:
            'A comprehensive full-body workout aimed at increasing overall strength.',
        exercises: ['ex1', 'ex3', 'ex5'],
        days: [],
        progression: [],
      ),
      Workout(
        id: 'w3',
        imageURL: "https://cdn.yogajournal.com/wp-content/uploads/2023/02/GettyImages-1066259522-scaled.jpg",
        createdBy: "Rony",
        createdAt: DateTime.now(),
        title: 'Yoga and Flexibility',
        difficulty: Difficulty.Beginner,
        time: 30,
        description:
            'A relaxing yoga routine to improve flexibility and reduce stress.',
        exercises: ['ex7', 'ex8', 'ex9'],
        days: [],
        progression: [],
      )
    ];
  }
}

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

enum Difficulty { Beginner, Intermediate, Advanced }
