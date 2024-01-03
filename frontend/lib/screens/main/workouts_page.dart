import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/workout/add_workout_page.dart';
import 'package:frontend/screens/workout/create_workout_page.dart';
import 'package:frontend/screens/workout/workout_page.dart';
import 'package:frontend/widgets/image_widget.dart';

class WorkoutsPage extends StatefulWidget {
  WorkoutsPage({Key? key}) : super(key: key);

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  late List<Workout> workouts;
  late List<Workout> queried;

  create_callback(Workout createdWorkout) {
    setState(() {
      workouts.add(createdWorkout);
      queried.add(createdWorkout);
    });
  }

  add_callback(Workout addedWorkout) {
    setState(() {
      if(workouts.where((i) => i.id == addedWorkout.id).toList().isEmpty){
        workouts.add(addedWorkout);
        queried.add(addedWorkout);
      }
    });
  }

  @override
  void initState() {
    workouts = Workout.db();
    queried = Workout.db();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Workouts",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
              )),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: SearchAnchor(builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onChanged: (query) {
                          searchWorkouts(query);
                        },
                        leading: const Icon(Icons.search),
                        trailing: const <Widget>[],
                      );
                    }, suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return <ListTile>[];
                    }),
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddWorkoutPage(add_callback)));
                          },
                          icon: Icon(Icons.add))),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateWorkoutPage(create_callback)));
                          },
                          icon: Icon(Icons.create))),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  itemCount: queried.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutPage(workout: queried[index])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CustomImageNetwork(
                                  imageURL: queried[index].imageURL,
                                  showIcon: true,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: FittedBox(
                                    child: Text(
                                        "${queried[index].title} • ${queried[index].createdBy}")))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void searchWorkouts(String query) {
    setState(() {
      if (query == "") {
        queried = workouts;
      } else {
        queried = workouts
            .where((w) =>
                w.createdBy.toLowerCase().contains(query.toLowerCase()) ||
                w.createdAt
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                w.days.toString().toLowerCase().contains(query.toLowerCase()) ||
                w.title
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                w.description
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                w.description
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                w.time.toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
