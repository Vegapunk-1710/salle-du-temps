import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/widgets/workout_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String dayName;
  late Workout? todayWorkout;
  late List<Workout> workouts;
  DateTime now = DateTime.now();
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
     workouts = Workout.db();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dayName = daysOfWeek[now.weekday - 1];
    todayWorkout = workouts.where((w) {
      if (w.days.isNotEmpty) {
        return w.days.contains(Workout.translateStringToDay(dayName));
      } else {
        return false;
      }
    }).firstOrNull;


    return SafeArea(
        child: Center(
            child: ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Let's Grind, Baher",
                      style: TextStyle(
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 100,),
                  Text(DateTime.now().toIso8601String().substring(0,10),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                ],
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$dayName's Workout",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 22))),
        todayWorkout == null
            ? const Center(
                child: Text("No Workouts For Today"),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height / 2.7,
                child: WorkoutCard(
                  workout: todayWorkout!,
                )),
      ],
    )));
  }
}
