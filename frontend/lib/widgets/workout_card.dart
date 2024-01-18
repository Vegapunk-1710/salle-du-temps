import 'package:flutter/material.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/workout/workout_page.dart';
import 'package:frontend/widgets/image_widget.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final AppState appState;
  final Function refreshCallback;
  const WorkoutCard({Key? key, required this.workout, required this.appState, required this.refreshCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WorkoutPage(
                      workout: workout,
                      appState: appState,
                      refreshCallback: refreshCallback,
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
                      imageURL: workout.imageURL,
                      showIcon: true,
                      fit: BoxFit.fitWidth)),
              Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text(workout.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Flexible(
                          child: Text(
                            workout.description,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Difficulty : ${workout.difficulty.name.toString()}",
                        ),
                        Text(
                          "Time : ~${workout.time} mins",
                        ),
                        Text(
                          "By : ${workout.createdBy}",
                        ),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}
