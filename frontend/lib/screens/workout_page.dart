import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/screens/exercise/add_exercise_page.dart';
import 'package:frontend/screens/exercise/create_exercise_page.dart';
import 'package:frontend/screens/exercise/order_exercise_page.dart';
import 'package:frontend/widgets/exercise_card.dart';

class WorkoutPage extends StatefulWidget {
  WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int exer_index = 0;
  List<Exercise> exercises = Exercise.examples().sublist(0, 5);

  callback(Exercise newExercise) {
    setState(() {
      exercises.add(newExercise);
    });
  }

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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddExercise(callback)));
                            },
                            icon: const Icon(Icons.add)),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateExercise(callback)));
                            },
                            icon: const Icon(Icons.create)),
                        IconButton(
                            onPressed: () {
                              List<Exercise> unordered = List.from(exercises);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderExercise(
                                            callback,unordered
                                          )));
                              exercises.clear();
                            },
                            icon: const Icon(Icons.stacked_bar_chart_sharp)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                int rmv_index = exer_index;
                                if (exercises.isNotEmpty) {
                                  if (exer_index == exercises.length - 1 &&
                                      exer_index > 0) {
                                    rmv_index = exer_index;
                                    exer_index -= 1;
                                  }
                                  Exercise removed =
                                      exercises.removeAt(rmv_index);
                                  var snackBar = SnackBar(
                                    content: Text(
                                        'Deleted Last Exercise : ${removed.title}'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        setState(() {
                                          exercises.add(removed);
                                        });
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              });
                            },
                            icon: const Icon(Icons.delete_forever))
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 300,
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
                      child: ExerciseCard(exercise: exercises[exer_index]));
                },
              ),
            ),
            const SizedBox(
              height: 100,
            )
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
            child: Text("Go !"),
          )
        ],
      ),
    );
  }
}
