class Workout {
  String id;
  String? imageURL;
  String title;
  Difficulty difficulty;
  int time;
  String description;
  List<String> exercises;
  List<Days>? days;

  Workout({
    required this.id,
    this.imageURL,
    required this.title,
    required this.difficulty,
    required this.time,
    required this.description,
    required this.exercises,
    this.days,
  });

  @override
  String toString() {
    return "id : $id\nimageURL : $imageURL \ntitle : $title\ndifficulty : $difficulty\ntime : $time\ndescription : $description\nfrequency : $days\exercises : $exercises\n";
  }

  static List<Workout> db() {
    return [
      Workout(
        id: 'w1',
        imageURL: null,
        title: 'Full Body Strength',
        difficulty: Difficulty.Advanced,
        time: 60,
        description:
            'A comprehensive full-body workout aimed at increasing overall strength.',
        // days: ['Monday', 'Wednesday', 'Friday'],
        exercises: ['ex1', 'ex3', 'ex5'],
      ),
      Workout(
        id: 'w3',
        imageURL: null,
        title: 'Yoga and Flexibility',
        difficulty: Difficulty.Beginner,
        time: 30,
        description:
            'A relaxing yoga routine to improve flexibility and reduce stress.',
        // days: ['Wednesday', 'Friday', 'Sunday'],
        exercises: ['ex7', 'ex8', 'ex9'],
      )
    ];
  }
}

enum Days{Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday}
enum Difficulty{Beginner, Intermediate, Advanced}
