import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';

class AddWorkoutPage extends StatefulWidget {
  final Function(Workout addedWorkout) addCallback;
  final Function(String searchQuery) searchCallback;
  AddWorkoutPage(this.searchCallback, this.addCallback, {Key? key})
      : super(key: key);

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  late List<Workout> workouts;
  late List<Workout> queried;
  List<String> selected = <String>[];

  @override
  void initState() {
    workouts = Workout.db();
    queried = Workout.db();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Add A Workout",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onChanged: (query) async {
                    List<Workout> searchedWorkouts =
                        await widget.searchCallback(query);
                    setState(() {
                      if (query.isEmpty) {
                        queried = workouts;
                      } else {
                        queried = searchedWorkouts;
                      }
                    });
                  },
                  leading: const Icon(Icons.search),
                  trailing: const <Widget>[],
                );
              }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                return <ListTile>[];
              }),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: queried.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(queried[index].title),
                      subtitle: FittedBox(
                        child: Row(
                          children: [
                            Text("By : ${queried[index].createdBy}, "),
                            Text(
                                "Difficulty : ${queried[index].difficulty.name}, "),
                            Text("Time : ~${queried[index].time} mins"),
                          ],
                        ),
                      ),
                      trailing: selected.contains(queried[index].id)
                          ? const Icon(Icons.check)
                          : const Icon(Icons.circle_outlined),
                      selected: selected.contains(queried[index].id),
                      enableFeedback: true,
                      onTap: () {
                        setState(() {
                          if (selected.contains(queried[index].id)) {
                            selected.remove(queried[index].id);
                          } else {
                            selected.add(queried[index].id);
                          }
                        });
                      },
                    ),
                  );
                }),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              heroTag: "addworkoutexitbtn",
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                List<Workout> selectedWorkouts =
                    workouts.where((w) => selected.contains(w.id)).toList();
                for (Workout w in selectedWorkouts) {
                  widget.addCallback(w);
                }
                Navigator.of(context).pop();
              },
              heroTag: "addworkoutbtn",
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
