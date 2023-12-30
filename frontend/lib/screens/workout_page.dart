import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/exercise/add_exercise_page.dart';
import 'package:frontend/screens/exercise/create_exercise_page.dart';
import 'package:frontend/screens/exercise/order_exercise_page.dart';
import 'package:frontend/widgets/exercise_card.dart';

class WorkoutPage extends StatefulWidget {
  final Workout workout;
  WorkoutPage({Key? key, required this.workout}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int exer_index = 0;
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

  Map<String, bool> selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  @override
  void initState() {
    exercises = Exercise.db()
        .where((i) => widget.workout.exercises.any((j) => i.id == j))
        .toList();
    super.initState();
  }

  callback(Exercise newExercise) {
    setState(() {
      if (exercises.where((i) => i.id == newExercise.id).toList().isEmpty) {
        exercises.add(newExercise);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.network(
            widget.workout.imageURL ??=
                "https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2022/05/StrengthLogs-4-Day-Bodybuilding-Split.jpg?fit=1000%2C593&ssl=1",
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.image));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.workout.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 22)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("DIFFICULTY : ${widget.workout.difficulty.name}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14)),
                    Text("TIME : ~${widget.workout.time} mins",
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14)),
                  ],
                ),
                widget.workout.days == null ||widget.workout.days?.length == 0
                    ? const Text("DAYS : Not Active",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14))
                    : widget.workout.days!.length == 7
                        ? const Text("DAYS : All Week",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14))
                        : Text(
                            "DAYS : ${widget.workout.days.toString().substring(1, widget.workout.days.toString().length - 1).replaceAll("Days.", "")}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14)),
              ],
            ),
          ),
          const Divider(),
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Description",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddExercise(callback)));
                          },
                          icon: const Icon(Icons.add)),
                      IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateExercise(callback)));
                          },
                          icon: const Icon(Icons.create)),
                      IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            List<Exercise> unordered = List.from(exercises);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderExercise(callback, unordered)));
                            exercises.clear();
                          },
                          icon: const Icon(Icons.stacked_bar_chart_sharp)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete this exercise ?"),
                                content: Text(
                                    "Are you sure you want to delete ${exercises[exer_index].title} from your workout ?"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
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
              controller:
                  PageController(viewportFraction: 0.9, keepPage: false),
              onPageChanged: (index) => setState(() => exer_index = index),
              itemBuilder: (context, index) {
                return AnimatedPadding(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    padding: EdgeInsets.all(exer_index == index ? 0.0 : 8.0),
                    child: ExerciseCard(
                      exercise: exercises[exer_index],
                      position: "${exer_index + 1}/${exercises.length}",
                    ));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Workout Schedule",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
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
                          setState(() {
                            selectedDays[day] = newValue!;
                            widget.workout.days ??= <Days>[];
                            if (selectedDays[day] == true) {
                              widget.workout.days!
                                  .add(Workout.translateStringToDay(day));
                            } else {
                              widget.workout.days!
                                  .remove(Workout.translateStringToDay(day));
                            }
                          });
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
            height: 120,
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
              },
              heroTag: "workoutexitbtn",
              child: const Icon(Icons.exit_to_app),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              print("Workout Started !!");
            },
            heroTag: "workoutstartbtn",
            child: const Text("Go !"),
          )
        ],
      ),
    );
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
}
