import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/screens/exercise/exercise_page.dart';
import 'package:frontend/widgets/image_widget.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final String? position;

  final Function(Exercise removedExercise) removedCallback;
  final Function(String exerciseId) getProgressionCallback;
  final Function(String exerciseId, String date, int weight, int sets, int reps)
      addProgressionCallback;
  final Function(String exerciseId, String date) deleteProgressionCallback;

  const ExerciseCard(
      {Key? key,
      this.position,
      required this.exercise,
      required this.removedCallback,
      required this.getProgressionCallback,
      required this.addProgressionCallback,
      required this.deleteProgressionCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExercisePage(
                    exercise: exercise,
                    removedCallback: removedCallback,
                    getProgressionCallback: getProgressionCallback,
                    addProgressionCallback: addProgressionCallback,
                    deleteProgressionCallback: deleteProgressionCallback)));
      },
      child: Card(
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 1,
                  child: CustomImageNetwork(
                    imageURL: exercise.imageURL,
                    showIcon: true,
                    fit: BoxFit.fitWidth,
                  )),
              Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text(exercise.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Type : ${exercise.type.name}",
                        ),
                        Text(
                          "Difficulty : ${exercise.difficulty.name}",
                        ),
                        Text(
                          "Time : ~${exercise.time} mins",
                        ),
                      ],
                    ),
                    trailing: position == null ? Text("") : Text(position!),
                  ))
            ],
          )),
    );
  }
}
