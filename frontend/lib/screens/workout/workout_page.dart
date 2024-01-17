import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/exercise/add_exercise_page.dart';
import 'package:frontend/screens/exercise/create_exercise_page.dart';
import 'package:frontend/screens/exercise/order_exercise_page.dart';
import 'package:frontend/screens/workout/start_workout_page.dart';
import 'package:frontend/widgets/exercise_card.dart';
import 'package:frontend/widgets/image_widget.dart';

class WorkoutPage extends StatefulWidget {
  final Workout workout;
  final AppState appState;
  final Function refreshCallback;
  WorkoutPage(
      {Key? key,
      required this.workout,
      required this.appState,
      required this.refreshCallback})
      : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int exer_index = 0;
  bool loading = true;
  late List<Exercise> exercises;
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  late Map<String, bool> selectedDays;

  @override
  void initState() {
    exercises = Exercise.db()
        .where((i) => widget.workout.exercises.any((j) => i.id == j))
        .toList();
    initDays();
    super.initState();
  }

  initDays() async {
    List<String> days = await widget.appState.getDays(widget.workout.id);
    setState(() {
      widget.workout.days =
          days.map((day) => Workout.translateStringToDay(day)).toList();
      selectedDays = {
        'Monday': widget.workout.days.contains(Days.Monday),
        'Tuesday': widget.workout.days.contains(Days.Tuesday),
        'Wednesday': widget.workout.days.contains(Days.Wednesday),
        'Thursday': widget.workout.days.contains(Days.Thursday),
        'Friday': widget.workout.days.contains(Days.Friday),
        'Saturday': widget.workout.days.contains(Days.Saturday),
        'Sunday': widget.workout.days.contains(Days.Sunday),
      };
      loading = false;
    });
  }

  callback(Exercise newExercise) {
    setState(() {
      if (exercises.where((i) => i.id == newExercise.id).toList().isEmpty) {
        exercises.add(newExercise);
      }
    });
  }

  endWorkoutCallback(List<Exercise> modifiedExercises, String time) {
    setState(() {
      exercises = modifiedExercises;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: RefreshProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageNetwork(
                      imageURL: widget.workout.imageURL,
                      showIcon: false,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(widget.workout.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22)),
                              ),
                              IconButton(
                                  onPressed: () {
                                    handleDeleteWorkout(context);
                                  },
                                  icon: const Icon(Icons.delete_forever))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "DIFFICULTY : ${widget.workout.difficulty.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14)),
                              Text("TIME : ~${widget.workout.time} mins",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14)),
                            ],
                          ),
                          widget.workout.days.isEmpty
                              ? const Text("DAYS : Not Active",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14))
                              : widget.workout.days.length == 7
                                  ? const Text("DAYS : All Week",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14))
                                  : Text(
                                      "DAYS : ${widget.workout.days.toString().substring(1, widget.workout.days.toString().length - 1).replaceAll("Days.", "")}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14)),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Description",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 22))),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(widget.workout.description,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Exercises",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 22)),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      handleAdd(context);
                                    },
                                    icon: const Icon(Icons.add)),
                                IconButton(
                                    onPressed: () {
                                      handleCreate(context);
                                    },
                                    icon: const Icon(Icons.create)),
                                IconButton(
                                    onPressed: () {
                                      handleOrder(context);
                                    },
                                    icon: const Icon(
                                        Icons.stacked_bar_chart_sharp)),
                                IconButton(
                                    onPressed: () {
                                      handleDeleteExercise(context);
                                    },
                                    icon: const Icon(Icons.delete_forever))
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3.1,
                      child: PageView.builder(
                        itemCount: exercises.length,
                        controller: PageController(
                            viewportFraction: 0.9, keepPage: false),
                        onPageChanged: (index) =>
                            setState(() => exer_index = index),
                        itemBuilder: (context, index) {
                          return AnimatedPadding(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.fastOutSlowIn,
                              padding: EdgeInsets.all(
                                  exer_index == index ? 0.0 : 8.0),
                              child: ExerciseCard(
                                exercise: exercises[exer_index],
                                position:
                                    "${exer_index + 1}/${exercises.length}",
                              ));
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Workout Schedule",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 22)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: daysOfWeek.map((String day) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Checkbox(
                                  value: selectedDays[day],
                                  onChanged: (bool? newValue) {
                                    handleDays(day, newValue);
                                  },
                                ),
                                Text(day),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ]),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.refreshCallback();
              },
              heroTag: "workoutexitbtn",
              child: const Icon(Icons.arrow_back),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StartWorkoutPage(exercises, endWorkoutCallback)));
            },
            heroTag: "workoutstartbtn",
            child: const Text("START"),
          )
        ],
      ),
    );
  }

  void handleAdd(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddExercise(callback)));
  }

  void handleCreate(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateExercise(callback)));
  }

  void handleOrder(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    List<Exercise> unordered = List.from(exercises);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderExercise(callback, unordered)));
    exercises.clear();
  }

  void handleDeleteExercise(BuildContext context) {
    if (exercises.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Delete this exercise ?"),
          content: Text(
              "Are you sure you want to delete ${exercises[exer_index].title} from your workout ?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("No")),
            TextButton(
                onPressed: () {
                  deleteExercise(context);
                  Navigator.pop(context, 'OK');
                },
                child: const Text("Yes")),
          ],
        ),
      );
    }
  }

  void handleDeleteWorkout(BuildContext context) {
    if (widget.appState.user.name == widget.workout.createdBy) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Delete this workout ?"),
          content: Text(
              "Are you sure you want to delete ${widget.workout.title} ? Select 'For Me' to remove the workout from your workouts OR 'For All' to permanently remove the workout."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("No")),
            TextButton(
                onPressed: () {
                  deleteWorkout(context, true);
                  Navigator.pop(context, 'OK');
                },
                child: const Text("For Me")),
            TextButton(
                onPressed: () {
                  deleteWorkout(context, false);
                  Navigator.pop(context, 'OK');
                },
                child: const Text("For All")),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Delete this workout ?"),
          content: Text(
              "Are you sure you want to delete ${widget.workout.title} from your workouts ?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("No")),
            TextButton(
                onPressed: () {
                  deleteWorkout(context, true);
                  Navigator.pop(context, 'OK');
                },
                child: const Text("Yes")),
          ],
        ),
      );
    }
  }

  void deleteExercise(BuildContext context) {
    setState(() {
      int rmv_index = exer_index;
      if (exercises.isNotEmpty) {
        if (exer_index == exercises.length - 1 && exer_index > 0) {
          rmv_index = exer_index;
          exer_index -= 1;
        }
        Exercise removed = exercises.removeAt(rmv_index);
        var snackBar = SnackBar(
          content: Text('Deleted Exercise : ${removed.title}'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                exercises.add(removed);
              });
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void deleteWorkout(BuildContext context, bool isForMe) {
    if (isForMe) {
      widget.appState.deleteWorkout(widget.workout.id);
    } else {
      widget.appState.deleteWorkoutForAll(widget.workout.id);
    }
    widget.appState.deleteDays(widget.workout.id);
    setState(() {
      widget.appState.user.workouts.remove(widget.workout);
      widget.refreshCallback();
    });
    Navigator.of(context).pop();
  }

  void handleDays(String day, bool? newValue) {
    setState(() {
      selectedDays[day] = newValue!;
      if (selectedDays[day] == true) {
        widget.workout.days.add(Workout.translateStringToDay(day));
      } else {
        widget.workout.days.remove(Workout.translateStringToDay(day));
      }
      final positions =
          daysOfWeek.asMap().map((ind, day) => MapEntry(day, ind));
      widget.workout.days.sort((first, second) {
        final firstPos = positions[first.name] ?? 8;
        final secondPos = positions[second.name] ?? 8;
        return firstPos.compareTo(secondPos);
      });
    });
    List<String> daysAsNames =
        widget.workout.days.map((day) => day.name).toList();
    widget.appState.addDays(widget.workout.id, daysAsNames);
    widget.refreshCallback();
  }
}
