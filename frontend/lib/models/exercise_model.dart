class Exercise {
  late String id;
  late String imageURL;
  late String createdBy;
  late DateTime createdAt;
  late String title;
  late Difficulty difficulty;
  late int time;
  late Type type;
  late String tutorial;
  late String setsreps;
  late List<(DateTime date, int weight, int maxSets, int maxReps)> progression;

  Exercise(
      {required this.id,
      required this.imageURL,
      required this.createdBy,
      required this.createdAt,
      required this.title,
      required this.difficulty,
      required this.time,
      required this.type,
      required this.tutorial,
      required this.setsreps,
      required this.progression});

  @override
  String toString() {
    return "id : $id\nimageURL : $imageURL \ntitle : $title\ndifficulty : $difficulty\ntime : $time\ntype : $type\ntutorial : $tutorial\nsetsreps : $setsreps\nprogression : $progression\n";
  }

  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageURL = json['imageURL'];
    createdBy = json['createdBy'];
    createdAt = DateTime.parse(json['createdAt']);
    title = json['title'];
    difficulty = translateStringToDifficulty(json['difficulty']);
    time = json['time'];
    type = translateStringToType(json['type']);
    tutorial = json['tutorial'];
    setsreps = json['setsreps'];
    progression = [];
  }

  static Difficulty translateStringToDifficulty(String name) {
    for (Difficulty d in Difficulty.values) {
      if (name == d.name) {
        return d;
      }
    }
    return Difficulty.Beginner;
  }

  static Type translateStringToType(String name) {
    for (Type t in Type.values) {
      if (name == t.name) {
        return t;
      }
    }
    return Type.Aerobic;
  }

  static List<Exercise> db() {
    return [
      Exercise(
          id: 'ex1',
          imageURL: "",
          createdBy: "Rony",
          createdAt: DateTime.now(),
          title: 'Push Ups',
          difficulty: Difficulty.Intermediate,
          time: 10,
          type: Type.Strength,
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [(DateTime.now(), 0, 3, 10), (DateTime.now(), 0, 3, 10)],
          tutorial:
              'Step 1: Get into a high plank position. Step 2: Lower your body keeping back straight. Step 3: Push back up.'),
      Exercise(
          id: 'ex2',
          title: 'Running',
          createdBy: "Rony",
          createdAt: DateTime.now(),
          imageURL: "",
          difficulty: Difficulty.Beginner,
          time: 30,
          type: Type.Strength,
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [(DateTime.now(), 0, 3, 10), (DateTime.now(), 0, 3, 10)],
          tutorial:
              'Step 1: Start with a warm-up walk. Step 2: Gradually increase your pace to a comfortable run.'),
      Exercise(
          id: 'ex3',
          title: 'Squats',
          createdBy: "Rony",
          createdAt: DateTime.now(),
          imageURL: "",
          difficulty: Difficulty.Intermediate,
          time: 15,
          type: Type.Stretching,
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [(DateTime.now(), 0, 3, 10), (DateTime.now(), 0, 3, 10)],
          tutorial:
              'Step 1: Stand with feet hip-width apart. Step 2: Bend knees and lower your body as if sitting in a chair. Step 3: Keep your back straight and return to standing.'),
      Exercise(
          id: 'ex4',
          title: 'Plank',
          createdBy: "Rony",
          createdAt: DateTime.now(),
          imageURL: "",
          difficulty: Difficulty.Advanced,
          time: 5,
          type: Type.Strength,
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [(DateTime.now(), 0, 3, 10), (DateTime.now(), 0, 3, 10)],
          tutorial:
              'Step 1: Get into a forearm plank position. Step 2: Ensure your body forms a straight line from head to heels. Step 3: Hold this position, keeping your core engaged.'),
      Exercise(
          id: 'ex5',
          title: 'Jump Rope',
          createdBy: "Rony",
          createdAt: DateTime.now(),
          imageURL: "",
          difficulty: Difficulty.Beginner,
          time: 20,
          type: Type.Strength,
          setsreps: 'Set 1: Max Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [(DateTime.now(), 0, 3, 10), (DateTime.now(), 0, 3, 10)],
          tutorial:
              'Step 1: Hold the rope handles and step in the middle of the rope. Step 2: Swing the rope over your head and jump over it as it comes down. Step 3: Keep a steady pace and maintain rhythm.'),
      Exercise(
          id: 'ex6',
          title: 'Bicycle Crunches',
          imageURL: "",
          createdBy: "Rony",
          createdAt: DateTime.now(),
          difficulty: Difficulty.Intermediate,
          time: 15,
          type: Type.Strength,
          setsreps: 'Set 1: 15 Reps. Set 2: 12 Reps. Set 3: 10 Reps.',
          progression: [(DateTime.now(), 0, 3, 15), (DateTime.now(), 0, 3, 12)],
          tutorial:
              'Step 1: Lie flat on your back. Step 2: Bring your knees in towards your chest and lift your shoulder blades off the ground. Step 3: Straighten one leg out while turning your upper body to the opposite side, bringing your elbow towards the opposite knee. Repeat on the other side.'),
      Exercise(
          id: 'ex7',
          title: 'Lunges',
          imageURL: "",
          createdBy: "Rony",
          createdAt: DateTime.now(),
          difficulty: Difficulty.Beginner,
          time: 10,
          type: Type.Strength,
          setsreps:
              'Set 1: 10 Reps each leg. Set 2: 8 Reps each leg. Set 3: 6 Reps each leg.',
          progression: [(DateTime.now(), 0, 3, 10), (DateTime.now(), 0, 3, 8)],
          tutorial:
              'Step 1: Stand straight with feet hip-width apart. Step 2: Take a step forward with one leg and lower your body until both knees are bent at a 90-degree angle. Step 3: Push back up and return to the starting position. Repeat with the other leg.'),
      Exercise(
          id: 'ex8',
          title: 'Pull-Ups',
          createdAt: DateTime.now(),
          imageURL: "",
          createdBy: "Rony",
          difficulty: Difficulty.Advanced,
          time: 20,
          type: Type.Strength,
          setsreps: 'Set 1: 5 Reps. Set 2: 4 Reps. Set 3: 3 Reps.',
          progression: [(DateTime.now(), 0, 3, 5), (DateTime.now(), 0, 3, 4)],
          tutorial:
              'Step 1: Grip the pull-up bar with your hands shoulder-width apart and palms facing away. Step 2: Pull yourself up until your chin is level with the bar. Step 3: Lower yourself back down to a full hang.'),
      Exercise(
          id: 'ex9',
          title: 'Box Jumps',
          createdBy: "Rony",
          createdAt: DateTime.now(),
          imageURL: "",
          difficulty: Difficulty.Intermediate,
          time: 15,
          type: Type.Stretching,
          setsreps: 'Set 1: 12 Reps. Set 2: 10 Reps. Set 3: 8 Reps.',
          progression: [(DateTime.now(), 0, 3, 12), (DateTime.now(), 0, 3, 10)],
          tutorial:
              'Step 1: Stand in front of a sturdy box or platform. Step 2: Jump onto the box with both feet landing softly. Step 3: Step back down and repeat.'),
      Exercise(
          id: 'ex10',
          title: 'Mountain Climbers',
          createdBy: "Rony",
          createdAt: DateTime.now(),
          imageURL: "",
          difficulty: Difficulty.Beginner,
          time: 10,
          type: Type.Strength,
          setsreps: 'Set 1: 30 Seconds. Set 2: 25 Seconds. Set 3: 20 Seconds.',
          progression: [(DateTime.now(), 0, 3, 30), (DateTime.now(), 0, 3, 25)],
          tutorial:
              'Step 1: Start in a plank position. Step 2: Bring one knee towards your chest, then quickly switch to the other leg, as if you’re running in place. Step 3: Keep your core engaged and back straight throughout.')
    ];
  }
}

enum Difficulty { Beginner, Intermediate, Advanced }

enum Type { Aerobic, Strength, Stretching, Balance }
