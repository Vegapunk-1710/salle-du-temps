import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/exercise_model.dart';

class ExercisePage extends StatefulWidget {
  final Exercise exercise;

  ExercisePage({Key? key, required this.exercise}) : super(key: key);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  TextEditingController progressionWeightController = TextEditingController();
  TextEditingController progressionSetsController = TextEditingController();
  TextEditingController progressionRepsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Image.network(widget.exercise.imageURL.toString() == "null"
                ? "https://info.totalwellnesshealth.com/hubfs/HealthBenefitsFitness.png"
                : widget.exercise.imageURL.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.exercise.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("DIFFICULTY : ${widget.exercise.difficulty}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14)),
                      Text("TIME : ~${widget.exercise.time} mins",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14)),
                    ],
                  ),
                  Text("TYPE : ${widget.exercise.type}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 14)),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text("Tutorial",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(widget.exercise.tutorial,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16))),
            ),
            const Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text("Recommended Sets/Reps",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(widget.exercise.setsreps,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16))),
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
                            widget.exercise.progression ??= <(String date, num weight, num maxSets, num maxReps)>[];
                            if (widget.exercise.progression!.isNotEmpty) {
                              var removed =
                                  widget.exercise.progression!.removeLast();
                              var snackBar = SnackBar(
                                content: Text(
                                    'Deleted Last Progression : ${removed.$1}'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      widget.exercise.progression!.add(removed);
                                      widget.exercise.progression!
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
                      padding: EdgeInsets.fromLTRB(5, 12, 0, 5),
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
                            widget.exercise.progression ??= <(String date, num weight, num maxSets, num maxReps)>[];
                            if (progressionWeightController.text.isNotEmpty &&
                                progressionSetsController.text.isNotEmpty &&
                                progressionRepsController.text.isNotEmpty) {
                              final date = DateTime.now();
                              String formattedDate =
                                  date.toIso8601String().split('T').first;
                              int weight =
                                  int.parse(progressionWeightController.text);
                              int sets =
                                  int.parse(progressionSetsController.text);
                              int reps =
                                  int.parse(progressionRepsController.text);
                              widget.exercise.progression!
                                  .add((formattedDate, weight, sets, reps));
                            }
                          });
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
              ),
            ),
            widget.exercise.progression.toString() == "null" ? Container() : Card(
              margin: const EdgeInsets.all(10),
              child: widget.exercise.progression!.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.exercise.progression!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                FittedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(widget
                                          .exercise.progression![index].$1),
                                      const Icon(Icons.arrow_right),
                                      Text(
                                          "${widget.exercise.progression![index].$2} max lbs"),
                                      const Icon(Icons.arrow_right),
                                      Text(
                                          "${widget.exercise.progression![index].$3} max sets"),
                                      const Icon(Icons.arrow_right),
                                      Text(
                                          "${widget.exercise.progression![index].$4} max reps")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: 100,
            )
          ]))),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              heroTag: "exerciseexitbtn",
              child: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressionTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  const ProgressionTextField(
      {super.key, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicWidth(
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            hintText: hint,
          ),
        ),
      ),
    );
  }
}
