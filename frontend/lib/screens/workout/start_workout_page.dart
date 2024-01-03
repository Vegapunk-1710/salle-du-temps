import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/screens/exercise/exercise_page.dart';

class StartWorkoutPage extends StatefulWidget {
  final List<Exercise> exercises;
  StartWorkoutPage(this.exercises, {Key? key}) : super(key: key);

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  TextEditingController progressionWeightController = TextEditingController();
  TextEditingController progressionSetsController = TextEditingController();
  TextEditingController progressionRepsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            Expanded(
                flex: 8,
                child: PageView.builder(
                  itemCount: widget.exercises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListView(
                        children: [
                          Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.exercises[index].title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22)),
                      Text("~ ${widget.exercises[index].time} mins",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14)),
                    ],
                                      ),
                                      const Divider(),
                                      const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Text("Tutorial",
                                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
                              Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(widget.exercises[index].tutorial,
                                      style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16))),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Text("Recommended Sets/Reps",
                                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
                              Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(widget.exercises[index].setsreps,
                                      style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16))),
                                    ],
                                  ),
                                ),
                                const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Personal Progression",
                                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
                                Center(
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    IconButton(
                    onPressed: () {
                      setState(() {
                        if (widget.exercises[index].progression.isNotEmpty) {
                          var removed =
                              widget.exercises[index].progression.removeLast();
                          var snackBar = SnackBar(
                            content: Text(
                                'Deleted Last Progression : ${removed.$1}'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                setState(() {
                                  widget.exercises[index].progression.add(removed);
                                  widget.exercises[index].progression
                                      .sort((a, b) => a.$1.compareTo(b.$1));
                                });
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                        }
                      });
                    },
                    icon: const Icon(Icons.delete_forever)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 12, 0, 0),
                                      child: Row(
                    children: [
                      ProgressionTextField(
                        hint: 'lbs',
                        controller: progressionWeightController,
                      ),
                      ProgressionTextField(
                        hint: 'sets',
                        controller: progressionSetsController,
                      ),
                      ProgressionTextField(
                        hint: 'reps',
                        controller: progressionRepsController,
                      ),
                    ],
                                      ),
                                    ),
                                    IconButton(
                    onPressed: () {
                      setState(() {
                        if (progressionWeightController.text.isNotEmpty &&
                            progressionSetsController.text.isNotEmpty &&
                            progressionRepsController.text.isNotEmpty) {
                          final date = DateTime.now();
                          int weight =
                              int.parse(progressionWeightController.text);
                          int sets =
                              int.parse(progressionSetsController.text);
                          int reps =
                              int.parse(progressionRepsController.text);
                          widget.exercises[index].progression
                              .add((date, weight, sets, reps));
                        }
                      });
                    },
                    icon: const Icon(Icons.add))
                                  ],
                                ),
                              ),
                            ),
                            widget.exercises[index].progression.toString() == "null" ? SizedBox.shrink() : widget.exercises[index].progression.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        FittedBox(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(widget
                                  .exercises[index].progression.last.$1.toIso8601String().split('T').first),
                              const Icon(Icons.arrow_right),
                              Text(
                                  "${widget.exercises[index].progression.last.$2} max lbs"),
                              const Icon(Icons.arrow_right),
                              Text(
                                  "${widget.exercises[index].progression.last.$3} max sets"),
                              const Icon(Icons.arrow_right),
                              Text(
                                  "${widget.exercises[index].progression.last.$4} max reps")
                            ],
                          ),
                        ),
                      ],
                    ),
                                      )
                                   
                                ),
                        ],
                      ),
                    );
                  },
                )),
            const Expanded(
              flex: 1,
              child: Text("Stopwatch"),
            )
          ]),
        ),
      ),
    );
  }
}
