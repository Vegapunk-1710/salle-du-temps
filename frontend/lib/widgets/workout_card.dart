import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/workout_page.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  const WorkoutCard({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WorkoutPage(workout: workout)));
      },
      child: Card(
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Image.network(
                      workout.imageURL ??=
                          "https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2022/05/StrengthLogs-4-Day-Bodybuilding-Split.jpg?fit=1000%2C593&ssl=1",
                      width: double.infinity,
                      fit: BoxFit.cover)),
              Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text(workout.title),
                    subtitle: FittedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout.description,
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Difficulty : ${workout.difficulty}",
                          ),
                          Text(
                            "Time : ~${workout.time} mins",
                          ),
                        ],
                      ),
                    ),
                    trailing: position == null ? Text("") : Text(position!),
                  ))
            ],
          )),
    );
  }
}
