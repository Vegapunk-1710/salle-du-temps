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
  int exerciseIndex = 0;
  bool loading = true;
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
    initWorkout();
    super.initState();
  }

  refreshCallback() {
    setState(() {
      widget.refreshCallback();
    });
  }

  initWorkout() async {
    List<String> days;
    List<Exercise> exercises;
    if (widget.workout.days.isEmpty) {
      days = await widget.appState.getDays(widget.workout.id);
    } else {
      days = widget.workout.days.map((day) => day.name).toList();
    }
    if (widget.workout.exercises.isEmpty) {
      exercises = await widget.appState.getWorkoutExercises(widget.workout.id);
    } else {
      exercises = widget.workout.exercises;
    }
    setState(() {
      widget.workout.exercises = exercises;
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

  getCallback() async {
    List<Exercise> exercises = await widget.appState.getExercises();
    return exercises;
  }

  searchCallback(String searchQuery) async {
    List<Exercise> exercises =
        await widget.appState.searchExercises(searchQuery);
    return exercises;
  }

  addCallback(List<Exercise> addedExercises) {
    addedExercises.forEach((exercise) async {
      if (widget.workout.exercises
          .where((i) => i.id == exercise.id)
          .toList()
          .isEmpty) {
        setState(() {
          widget.workout.exercises.add(exercise);
        });
        await widget.appState.addExercise(exercise.id, widget.workout.id);
      }
    });
  }

  orderCallback(List<Exercise> reorderedExercises) {
    for (int i = 0; i < reorderedExercises.length; i++) {
      setState(() {
        widget.workout.exercises[i] = reorderedExercises[i];
      });
      widget.appState
          .updateOrder(reorderedExercises[i].id, widget.workout.id, i + 1);
    }
  }

  createCallback(Map<String, dynamic> data) async {
    Exercise? createdExercise = await widget.appState.createExercise(data);
    if (createdExercise != null) {
      setState(() {
        widget.workout.exercises.add(createdExercise);
      });
      widget.appState.addExercise(createdExercise.id, widget.workout.id);
    }
  }

  endWorkoutCallback(List<Exercise> modifiedExercises, String time) {
    setState(() {
      // exercises = modifiedExercises;
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.workout.days.isEmpty
                                  ? const Text("DAYS : Not Active",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14))
                                  : widget.workout.days.length == 7
                                      ? const Text("DAYS : All Week",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14))
                                      : Flexible(
                                          child: Text(
                                              "DAYS : ${widget.workout.days.toString().substring(1, widget.workout.days.toString().length - 1).replaceAll("Days.", "")}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14)),
                                        ),
                              Flexible(
                                child: Text("BY : ${widget.workout.createdBy}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14)),
                              ),
                            ],
                          )
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
                            widget.appState.user.name == widget.workout.createdBy ? Row(
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
                            ) : const SizedBox(),
                          ],
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3.1,
                      child: PageView.builder(
                        itemCount: widget.workout.exercises.length,
                        controller: PageController(
                            viewportFraction: 0.9, keepPage: false),
                        onPageChanged: (index) =>
                            setState(() => exerciseIndex = index),
                        itemBuilder: (context, index) {
                          return AnimatedPadding(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.fastOutSlowIn,
                              padding: EdgeInsets.all(
                                  exerciseIndex == index ? 0.0 : 8.0),
                              child: ExerciseCard(
                                exercise:
                                    widget.workout.exercises[exerciseIndex],
                                position:
                                    "${exerciseIndex + 1}/${widget.workout.exercises.length}",
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
                      builder: (context) => StartWorkoutPage(
                          widget.workout.exercises, endWorkoutCallback)));
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddExercise(addCallback, getCallback, searchCallback)));
  }

  void handleCreate(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateExercise(createCallback)));
  }

  void handleOrder(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    List<Exercise> unordered = List.from(widget.workout.exercises);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderExercise(orderCallback, unordered)));
  }

  void handleDeleteExercise(BuildContext context) {
    if (widget.workout.exercises.isNotEmpty) {
      if (widget.appState.user.name ==
          widget.workout.exercises[exerciseIndex].createdBy) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Delete this exercise ?"),
            content: Text(
                "Are you sure you want to delete '${widget.workout.exercises[exerciseIndex].title}' ? Select 'For Me' to remove the exercise from this workout OR 'For All' to permanently remove the exercise."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    deleteExercise(context, true);
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text("For Me")),
              TextButton(
                  onPressed: () {
                    deleteExercise(context, false);
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
            title: const Text("Delete this exercise ?"),
            content: Text(
                "Are you sure you want to delete '${widget.workout.exercises[exerciseIndex].title}' from this workout ?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    deleteExercise(context, true);
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text("Yes")),
            ],
          ),
        );
      }
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

  void deleteExercise(BuildContext context, bool isForMe) {
    if (isForMe) {
      widget.appState.deleteExercise(
          widget.workout.id, widget.workout.exercises[exerciseIndex].id);
    } else {
      widget.appState.deleteExerciseForAll(
          widget.workout.id, widget.workout.exercises[exerciseIndex].id);
    }
    setState(() {
      widget.workout.exercises.remove(widget.workout.exercises[exerciseIndex]);
      if(exerciseIndex > 0){
        exerciseIndex -= 1;
      }
      widget.refreshCallback();
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
