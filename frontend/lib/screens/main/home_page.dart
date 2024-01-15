import 'package:flutter/material.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/body/body_prog_page.dart';
import 'package:frontend/widgets/workout_card.dart';

class HomePage extends StatefulWidget {
  final AppState appState;
  HomePage(this.appState, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String dayName;
  Workout? todayWorkout;

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
    if (widget.appState.user.workouts.isEmpty) {
      todayWorkout = null;
    }
    else{
      //need an algo for that
       todayWorkout = widget.appState.user.workouts[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dayName = daysOfWeek[now.weekday - 1];

    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text("Let's Grind, ${widget.appState.user.name}",
                                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Flexible(
                                child: Text(
                                                "${DateTime.now().toIso8601String().substring(0, 10).split("-")[1]}/${DateTime.now().toIso8601String().substring(0, 10).split("-")[2]}",
                                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                              ),
                            ],
                          )),
                Column(
                  children: [
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
                ),
                SizedBox(height: 100,)
              ],
            ));
  }
}
