class Workout {
  String id;
  String? imageURL;
  String title;
  String difficulty;
  num time;
  String description;
  List<String> frequency;
  List<String> exercises;

  Workout({
    required this.id,
    this.imageURL,
    required this.title,
    required this.difficulty,
    required this.time,
    required this.description,
    required this.frequency,
    required this.exercises,
  });

  @override
  String toString() {
    return "id : $id\nimageURL : $imageURL \ntitle : $title\ndifficulty : $difficulty\ntime : $time\ndescription : $description\nfrequency : $frequency\exercises : $exercises\n";
  }

  static List<Workout> db() {
    return [
      Workout(
        id: 'w1',
        imageURL: null,
        title: 'Full Body Strength',
        difficulty: 'Hard',
        time: 60,
        description: 'A comprehensive full-body workout aimed at increasing overall strength.',
        frequency: ['Monday', 'Wednesday', 'Friday'],
        exercises: ['ex1', 'ex3', 'ex5'],
      ),
      Workout(
        id: 'w3',
        imageURL: '',
        title: 'Yoga and Flexibility',
        difficulty: 'Easy',
        time: 30,
        description: 'A relaxing yoga routine to improve flexibility and reduce stress.',
        frequency: ['Wednesday', 'Friday', 'Sunday'],
        exercises: ['ex7', 'ex8', 'ex9'],
      )
    ];
  }
}
