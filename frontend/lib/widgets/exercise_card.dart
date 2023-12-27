import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Image.network(
                    "https://t4.ftcdn.net/jpg/03/17/72/47/360_F_317724775_qHtWjnT8YbRdFNIuq5PWsSYypRhOmalS.jpg",
                    width: double.infinity,
                    fit: BoxFit.cover)),
            Expanded(
              flex: 1,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        "Difficulty : ${exercise.difficulty}",
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "Type : ${exercise.type}",
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "Time : ~${exercise.time} mins",
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
