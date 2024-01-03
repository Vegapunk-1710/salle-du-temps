import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/workout/workout_page.dart';
import 'package:frontend/widgets/image_widget.dart';

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
                  child: CustomImageNetwork(imageURL: workout.imageURL,showIcon: true,)
                  ),
              Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text(workout.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${workout.description.substring(0, 33)}...",
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Difficulty : ${workout.difficulty.name.toString()}",
                        ),
                        Text(
                          "Time : ~${workout.time} mins",
                        ),
                        workout.days == null || workout.days!.isEmpty
                            ? const Text("Days : Not Active")
                            : workout.days!.length == 7
                                ? const Text("Days : All Week")
                                : Text(
                                    "Days : ${workout.days.toString().substring(1, workout.days.toString().length - 1).replaceAll("Days.", "")}"),
                      ],
                    ),
                    // trailing: position == null ? Text("") : Text(position!),
                  ))
            ],
          )),
    );
  }
}
