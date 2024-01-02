import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/workout_page.dart';
import 'package:frontend/widgets/image_widget.dart';

class WorkoutsPage extends StatefulWidget {
  WorkoutsPage({Key? key}) : super(key: key);

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  late List<Workout> workouts;

  @override
  void initState() {
    workouts = Workout.db();
    // myPrograms = programs.where((p) => p.createdBy == creator).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: workouts.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            if (index == workouts.length) {
              return GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Card(
                    elevation: 10,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Create New Program",
                            style: Theme.of(context).textTheme.bodyLarge),
                        const Icon(Icons.create),
                      ],
                    )),
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WorkoutPage(workout: workouts[index])));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CustomImageNetwork(imageURL: workouts[index].imageURL, showIcon: true,),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: FittedBox(
                              child: Text(
                                  "${workouts[index].title} • ${workouts[index].createdBy}")))
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}


