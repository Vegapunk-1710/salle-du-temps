import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';

class OrderExercise extends StatefulWidget {
  final List<Exercise> exercises;
  final Function(List<Exercise> reorderedExercises) callback;
  OrderExercise(this.callback, this.exercises, {Key? key}) : super(key: key);

  @override
  State<OrderExercise> createState() => _OrderExerciseState();
}

class _OrderExerciseState extends State<OrderExercise> {
  late List<Exercise> unorderedExercises;
  @override
  void initState() {
    super.initState();
    unorderedExercises = List.from(widget.exercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Reorder Your Exercises",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            ),
            ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: widget.exercises.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    _reorderExercises(oldIndex, newIndex);
                  });
                },
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    key: ValueKey(widget.exercises[index]),
                    elevation: 2,
                    child: ListTile(
                      title: Text(widget.exercises[index].title),
                      subtitle: FittedBox(
                        child: Row(
                          children: [
                            Text("Type : ${widget.exercises[index].type.name}, "),
                            Text(
                                "Difficulty : ${widget.exercises[index].difficulty.name}, "),
                            Text("Time : ~${widget.exercises[index].time} mins"),
                          ],
                        ),
                      ),
                      trailing: Text((index + 1).toString()),
                      enableFeedback: true,
                    ),
                  );
                }),
            const SizedBox(
              height: 100,
            )
          ],
        )),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                widget.callback(unorderedExercises);
                Navigator.of(context).pop();
              },
              heroTag: "orderexerciseexitbtn",
              child: const  Icon(Icons.arrow_back),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                widget.callback(widget.exercises);
                Navigator.of(context).pop();
              },
              heroTag: "orderexercisebtn",
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }

  void _reorderExercises(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Exercise reordered = widget.exercises.removeAt(oldIndex);
    widget.exercises.insert(newIndex, reordered);
  }
}
