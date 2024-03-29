import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';

class AddWorkoutPage extends StatefulWidget {
  final Function(Workout addedWorkout) addCallback;
  final Function(String searchQuery) searchCallback;
  final Function() getCallback;
  AddWorkoutPage(this.getCallback, this.searchCallback, this.addCallback,
      {Key? key})
      : super(key: key);

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  bool loading = true;
  late List<Workout> workouts;
  late List<Workout> queried;
  late Map<String, Workout> selected;
  bool isSearching = false;
  Timer? _debounce = Timer(const Duration(milliseconds: 500), () {});

  @override
  void initState() {
    initWorkouts();
    super.initState();
  }

  initWorkouts() async {
    List<Workout> returnedWorkouts = await widget.getCallback();
    setState(() {
      workouts = returnedWorkouts;
      queried = workouts;
      selected = {};
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: loading
              ? const Center(child: RefreshProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Add A Workout",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 22)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchAnchor(builder: (BuildContext context,
                            SearchController controller) {
                          return SearchBar(
                            controller: controller,
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                            onChanged: (query) {
                              if (_debounce?.isActive ?? false)
                                _debounce?.cancel();
                              _debounce = Timer(
                                  const Duration(milliseconds: 500), () async {
                                List<Workout> searchedWorkouts =
                                    await widget.searchCallback(query);
                                setState(() {
                                  if (query.isEmpty) {
                                    isSearching = false;
                                    queried = workouts;
                                  } else {
                                    isSearching = true;
                                    queried = searchedWorkouts;
                                  }
                                });
                              });
                            },
                            leading: const Icon(Icons.search),
                            trailing: const <Widget>[],
                          );
                        }, suggestionsBuilder: (BuildContext context,
                            SearchController controller) {
                          return <ListTile>[];
                        }),
                      ),
                      isSearching ? SizedBox.shrink() : Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Latest Workouts (${queried.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 22)),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics : const NeverScrollableScrollPhysics(),
                          itemCount: queried.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(queried[index].title),
                                subtitle: FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                          "By : ${queried[index].createdBy}, "),
                                      Text(
                                          "Difficulty : ${queried[index].difficulty.name}, "),
                                      Text(
                                          "Time : ~${queried[index].time} mins"),
                                    ],
                                  ),
                                ),
                                trailing:
                                    selected.containsKey(queried[index].id)
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.circle_outlined),
                                selected:
                                    selected.containsKey(queried[index].id),
                                enableFeedback: true,
                                onTap: () {
                                  setState(() {
                                    if (selected
                                        .containsKey(queried[index].id)) {
                                      selected.remove(queried[index].id);
                                    } else {
                                      selected[queried[index].id] =
                                          queried[index];
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
                List<Workout> selectedWorkouts = selected.values.toList();
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
