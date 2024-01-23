import 'package:flutter/material.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/widgets/workout_card.dart';

class HomePage extends StatefulWidget {
  final AppState appState;
  final Function refreshCallback;
  HomePage(this.appState, this.refreshCallback , {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Workout? todayWorkout;

  @override
  void initState() {
    todayWorkout = widget.appState.getTodaysWorkout();
    super.initState();
  }

  refreshCallback() {
    widget.refreshCallback();
    setState(() {
      todayWorkout = widget.appState.getTodaysWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22)),
                ),
                const SizedBox(
                  width: 100,
                ),
                Flexible(
                  child: Text(
                      "${DateTime.now().toIso8601String().substring(0, 10).split("-")[1]}/${DateTime.now().toIso8601String().substring(0, 10).split("-")[2]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22)),
                ),
              ],
            )),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${widget.appState.dayName}'s Workout",
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
                      appState: widget.appState,
                      refreshCallback: refreshCallback,
                    )),
          ],
        ),
        const SizedBox(
          height: 100,
        )
      ],
    ));
  }
}
