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
      child: Column(
        children: [
          const Expanded(
              flex: 6,
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
                    flex: 10,
                    child: SearchAnchor(
                        builder: (BuildContext context, SearchController controller) {
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
                  Expanded(flex:2,child: IconButton(onPressed: (){}, icon:Icon(Icons.add))),
                  Expanded(flex:2,child: IconButton(onPressed: (){}, icon:Icon(Icons.create))),
                  Expanded(flex:2,child: IconButton(onPressed: (){}, icon:Icon(Icons.stacked_bar_chart_sharp))),
                  Expanded(flex:2,child: IconButton(onPressed: (){}, icon:Icon(Icons.delete_forever_rounded))),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  itemCount: workouts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
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
                                child: CustomImageNetwork(
                                  imageURL: workouts[index].imageURL,
                                  showIcon: true,
                                ),
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
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void searchWorkouts(String query) {
    setState(() {});
  }
}
