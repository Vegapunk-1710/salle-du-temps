import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/screens/exercise/exercise_page.dart';
import 'package:frontend/widgets/image_widget.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final String? position;
  final Function(Exercise removedExercise) removedCallback;
  const ExerciseCard({Key? key, this.position, required this.exercise, required this.removedCallback})
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
                    )));
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
