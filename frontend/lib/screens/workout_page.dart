import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/widgets/exercise_card.dart';

class WorkoutPage extends StatefulWidget {
  WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int exer_index = 0;
  List<Exercise> exercises = Exercise.examples();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Image.network(
                'https://prod-ne-cdn-media.puregym.com/media/819394/gym-workout-plan-for-gaining-muscle_header.jpg?quality=80'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("WORKOUT TITLE",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                  Text("WORKOUT DIFF/TIME/MISC",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18))
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Description",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Exercises",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3.2,
              child: PageView.builder(
                itemCount: exercises.length,
                controller: PageController(viewportFraction: 0.8),
                onPageChanged: (index) => setState(() => exer_index = index),
                itemBuilder: (context, index) {
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    padding: EdgeInsets.all(exer_index == index ? 0.0 : 8.0),
                    child: ExerciseCard(exercise: exercises[exer_index])
                  );
                },
              ),
            ),
          ]))),
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
            child: const Text("GO"),
          )
        ],
      ),
    );
  }
}
