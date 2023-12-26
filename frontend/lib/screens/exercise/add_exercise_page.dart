import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/widgets/exercise_card.dart';

class AddExercise extends StatefulWidget {
  final Function(Exercise newExercise) callback;
  AddExercise(this.callback, {Key? key}) : super(key: key);

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  List<Exercise> newExercises = Exercise.examples().sublist(5);
  List<Exercise> queriedExercises = Exercise.examples().sublist(5);
  List<int> indices = <int>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Add An Exercise To Your Workout",
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
                onTap: () {
                  // controller.openView();
                },
                onChanged: (query) {
                  setState(() {
                    if (query.isEmpty) {
                      queriedExercises = newExercises;
                    }
                    else{
                      queriedExercises = newExercises
                      .where((i) =>
                          i.title.toLowerCase().contains(query.toLowerCase()) ||
                          i.type.toLowerCase().contains(query.toLowerCase()) ||
                          i.difficulty.toLowerCase().contains(query.toLowerCase()) ||
                          i.time.toString().contains(query))
                      .toList();
                    }
                  });
                },
                leading: const Icon(Icons.search),
                trailing: <Widget>[],
              );
            }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            }),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: queriedExercises.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  // color: indices.contains(index) ? Theme.of(context).hoverColor : Theme.of(context).cardColor,
                  child: ListTile(
                    title: Text(queriedExercises[index].title),
                    subtitle: FittedBox(
                      child: Row(
                        children: [
                          Text("Type : ${queriedExercises[index].type}, "),
                          Text(
                              "Difficulty : ${queriedExercises[index].difficulty}, "),
                          Text("Time : ~${queriedExercises[index].time} mins"),
                        ],
                      ),
                    ),
                    trailing: indices.contains(index)
                        ? const Icon(Icons.check)
                        : const Icon(Icons.circle_outlined),
                    selected: indices.contains(index),
                    enableFeedback: true,
                    // tileColor: Colors.red,
                    onTap: () {
                      setState(() {
                        if (indices.contains(index)) {
                          indices.remove(index);
                        } else {
                          indices.add(index);
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
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              heroTag: "addexerciseexitbtn",
              child: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
    );
  }

  void submitExercise() {
    Navigator.of(context).pop();
  }
}
