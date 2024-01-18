import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/exercise_model.dart';

class AddExercise extends StatefulWidget {
  final Function(Exercise newExercise) addCallback;
  final Function() getCallback;
  final Function(String searchQuery) searchCallback;
  AddExercise(this.addCallback, this.getCallback, this.searchCallback,
      {Key? key})
      : super(key: key);

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  bool loading = true;
  late List<Exercise> newExercises;
  late List<Exercise> queriedExercises;
  late List<String> selected;
  Timer? _debounce = Timer(const Duration(milliseconds: 100),(){});

  @override
  void initState() {
    initExercises();
    super.initState();
  }

  initExercises() async {
    List<Exercise> returnedExercises = await widget.getCallback();
    setState(() {
      newExercises = returnedExercises;
      queriedExercises = newExercises;
      selected = <String>[];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: loading
              ? const Center(
                  child: RefreshProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Add An Exercise",
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
                               if (_debounce?.isActive ?? false) _debounce?.cancel();
                                _debounce = Timer(const Duration(milliseconds: 100), () async {
                              List<Exercise> searchedExercises =
                                  await widget.searchCallback(query);
                                  print(query);
                                  setState(() {
                                    if (query.isEmpty) {
                                      queriedExercises = newExercises;
                                    } else {
                                      queriedExercises = searchedExercises;
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
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: queriedExercises.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(queriedExercises[index].title),
                                subtitle: FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                          "Type : ${queriedExercises[index].type.name}, "),
                                      Text(
                                          "Difficulty : ${queriedExercises[index].difficulty.name}, "),
                                      Text(
                                          "Time : ~${queriedExercises[index].time} mins"),
                                    ],
                                  ),
                                ),
                                trailing: selected
                                        .contains(queriedExercises[index].id)
                                    ? const Icon(Icons.check)
                                    : const Icon(Icons.circle_outlined),
                                selected: selected
                                    .contains(queriedExercises[index].id),
                                enableFeedback: true,
                                onTap: () {
                                  setState(() {
                                    if (selected
                                        .contains(queriedExercises[index].id)) {
                                      selected
                                          .remove(queriedExercises[index].id);
                                    } else {
                                      selected.add(queriedExercises[index].id);
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
              heroTag: "addexerciseexitbtn",
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                List<Exercise> selectedExercises = newExercises
                    .where((exercise) => selected.contains(exercise.id))
                    .toList();
                for (Exercise s in selectedExercises) {
                  widget.addCallback(s);
                }
                Navigator.of(context).pop();
              },
              heroTag: "addexercisebtn",
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
