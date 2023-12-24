class Exercise {
  String id;
  // String? imageURL;
  String title;
  String difficulty;
  num time;
  String type;
  String tutorial;
  String setsreps;
  List<(String date, num weight, num maxSets, num maxReps)> progression;

  Exercise(
      {required this.id,
      required this.title,
      required this.difficulty,
      required this.time,
      required this.type,
      required this.tutorial,
      required this.setsreps,
      required this.progression});

  static List<Exercise> examples() {
    return [
      Exercise(
          id: 'ex1',
          title: 'Push Ups',
          difficulty: 'Medium',
          time: 10,
          type: 'Strength',
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [('2023-01-01', 0, 3, 10), ('2023-02-01', 0, 3, 10)],
          tutorial:
              'Step 1: Get into a high plank position. Step 2: Lower your body keeping back straight. Step 3: Push back up.'),
      Exercise(
          id: 'ex2',
          title: 'Running',
          difficulty: 'Easy',
          time: 30,
          type: 'Cardio',
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [('2023-01-01', 0, 3, 10), ('2023-02-01', 0, 3, 10)],
          tutorial:
              'Step 1: Start with a warm-up walk. Step 2: Gradually increase your pace to a comfortable run.'),
      Exercise(
          id: 'ex3',
          title: 'Squats',
          difficulty: 'Medium',
          time: 15,
          type: 'Strength',
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [('2023-01-01', 0, 3, 10), ('2023-02-01', 0, 3, 10)],
          tutorial:
              'Step 1: Stand with feet hip-width apart. Step 2: Bend knees and lower your body as if sitting in a chair. Step 3: Keep your back straight and return to standing.'),
      Exercise(
          id: 'ex4',
          title: 'Plank',
          difficulty: 'Hard',
          time: 5,
          type: 'Core',
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [('2023-01-01', 0, 3, 10), ('2023-02-01', 0, 3, 10)],
          tutorial:
              'Step 1: Get into a forearm plank position. Step 2: Ensure your body forms a straight line from head to heels. Step 3: Hold this position, keeping your core engaged.'),
      Exercise(
          id: 'ex5',
          title: 'Jump Rope',
          difficulty: 'Easy',
          time: 20,
          type: 'Cardio',
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [('2023-01-01', 0, 3, 10), ('2023-02-01', 0, 3, 10)],
          tutorial:
              'Step 1: Hold the rope handles and step in the middle of the rope. Step 2: Swing the rope over your head and jump over it as it comes down. Step 3: Keep a steady pace and maintain rhythm.')
    ];
  }
}
