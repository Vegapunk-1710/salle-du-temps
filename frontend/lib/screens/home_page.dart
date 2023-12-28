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
  DateTime now = DateTime.now();
  final List<Workout> workouts = Workout.db();

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'jan',
      'feb',
      'mar',
      'april',
      'may',
      'jun',
      'july',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    String day = now.day.toString();
    String month = months[now.month - 1].toUpperCase();

    return SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.9,
            child: WorkoutCard(
              workout: workouts[0],
            )
          )
        )
      );
  }
}
