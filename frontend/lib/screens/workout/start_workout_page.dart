import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/screens/exercise/exercise_page.dart';

class StartWorkoutPage extends StatefulWidget {
  final List<Exercise> exercises;
  final Function(List<Exercise> modifiedExercises, String time)
      endWorkoutCallback;
  StartWorkoutPage(this.exercises, this.endWorkoutCallback, {Key? key})
      : super(key: key);

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  final stopwatch = Stopwatch();
  bool isStarted = false;
  bool isOnBreak = false;
  bool isStopped = false;
  String leftButtonText = "START";
  Color leftButtonColor = Colors.green;
  int page_index = 0;
  TextEditingController progressionWeightController = TextEditingController();
  TextEditingController progressionSetsController = TextEditingController();
  TextEditingController progressionRepsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {});
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Let's Train!",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
              ),
            ),
            Expanded(
                flex: 13,
                child: PageView.builder(
                  onPageChanged: (index) => setState(() {
                    page_index = index;
                  }),
                  itemCount: widget.exercises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(widget.exercises[page_index].title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22)),
                                      ),
                                      Flexible(
                                        child: Text(
                                            "${page_index+1}/${widget.exercises.length}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14)
                                            ),
                                      ),
                                      Flexible(
                                        child: Text(
                                            "~ ${widget.exercises[page_index].time} mins",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14)
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Text("Tutorial",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22))),
                                  Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                          widget.exercises[page_index].tutorial,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16))),
                                  const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Text("Recommended Sets/Reps",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22))),
                                  Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                          widget.exercises[page_index].setsreps,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16))),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Personal Progression",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22))),
                            Center(
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (widget.exercises[page_index]
                                                .progression.isNotEmpty) {
                                              var removed = widget
                                                  .exercises[page_index]
                                                  .progression
                                                  .removeLast();
                                              var snackBar = SnackBar(
                                                content: Text(
                                                    'Deleted Last Progression : ${removed.$1}'),
                                                action: SnackBarAction(
                                                  label: 'Undo',
                                                  onPressed: () {
                                                    setState(() {
                                                      widget
                                                          .exercises[page_index]
                                                          .progression
                                                          .add(removed);
                                                      widget
                                                          .exercises[page_index]
                                                          .progression
                                                          .sort((a, b) => a.$1
                                                              .compareTo(b.$1));
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
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 12, 0, 0),
                                      child: Row(
                                        children: [
                                          ProgressionTextField(
                                            hint: 'lbs',
                                            controller:
                                                progressionWeightController,
                                          ),
                                          ProgressionTextField(
                                            hint: 'sets',
                                            controller:
                                                progressionSetsController,
                                          ),
                                          ProgressionTextField(
                                            hint: 'reps',
                                            controller:
                                                progressionRepsController,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (progressionWeightController
                                                    .text.isNotEmpty &&
                                                progressionSetsController
                                                    .text.isNotEmpty &&
                                                progressionRepsController
                                                    .text.isNotEmpty) {
                                              final date = DateTime.now();
                                              int weight = int.parse(
                                                  progressionWeightController
                                                      .text);
                                              int sets = int.parse(
                                                  progressionSetsController
                                                      .text);
                                              int reps = int.parse(
                                                  progressionRepsController
                                                      .text);
                                              widget.exercises[page_index]
                                                  .progression
                                                  .add((
                                                date,
                                                weight,
                                                sets,
                                                reps
                                              ));
                                            }
                                          });
                                        },
                                        icon: const Icon(Icons.add))
                                  ],
                                ),
                              ),
                            ),
                            widget.exercises[page_index].progression
                                        .toString() ==
                                    "null"
                                ? const SizedBox.shrink()
                                : widget.exercises[page_index].progression
                                        .isEmpty
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(widget
                                                        .exercises[page_index]
                                                        .progression
                                                        .last
                                                        .$1
                                                        .toIso8601String()
                                                        .split('T')
                                                        .first),
                                                    const Icon(
                                                        Icons.arrow_right),
                                                    Text(
                                                        "${widget.exercises[page_index].progression.last.$2} max lbs"),
                                                    const Icon(
                                                        Icons.arrow_right),
                                                    Text(
                                                        "${widget.exercises[page_index].progression.last.$3} max sets"),
                                                    const Icon(
                                                        Icons.arrow_right),
                                                    Text(
                                                        "${widget.exercises[page_index].progression.last.$4} max reps")
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                          ],
                        )),
                      ),
                    );
                  },
                )),
            Expanded(
              flex: 2,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (page_index == 0) {
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              page_index -= 1;
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_back)),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (!isStarted) {
                              isStarted = true;
                              stopwatch.start();
                              leftButtonText = "BREAK";
                              leftButtonColor = Colors.orange;
                              return;
                            }
                            if (isStarted && !isOnBreak) {
                              isOnBreak = true;
                              stopwatch.stop();
                              leftButtonText = "RESUME";
                              leftButtonColor = Colors.blue;
                              return;
                            }
                            if (isStarted && isOnBreak) {
                              isOnBreak = false;
                              stopwatch.start();
                              leftButtonText = "BREAK";
                              leftButtonColor = Colors.orange;
                              return;
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: leftButtonColor,
                        ),
                        child: Text(leftButtonText)),
                    Text(stopwatch.elapsed.toString().split(".").first,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () {
                          widget.endWorkoutCallback(widget.exercises,
                              stopwatch.elapsed.toString().split(".").first);
                          Navigator.of(context).pop();
                        },
                        child: const Text("END")),
                    IconButton(
                        onPressed: () {
                          if (page_index == widget.exercises.length - 1) {
                            widget.endWorkoutCallback(widget.exercises,
                              stopwatch.elapsed.toString().split(".").first);
                          Navigator.of(context).pop();
                          } else {
                            setState(() {
                              page_index += 1;
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_forward)),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
