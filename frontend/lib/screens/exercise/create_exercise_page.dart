import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/exercise_model.dart';

class CreateExercise extends StatefulWidget {
  final Function(Exercise newExercise) callback;
  CreateExercise(this.callback, {Key? key}) : super(key: key);

  @override
  State<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  int step_index = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  TextEditingController tutotialController = TextEditingController();
  TextEditingController setsrepsController = TextEditingController();
  String selectedDifficulty = "Beginner";
  List<DropdownMenuItem<String>> difficulties = [
    const DropdownMenuItem(child: Text("Beginner"), value: "Beginner"),
    const DropdownMenuItem(child: Text("Intermediate"), value: "Intermediate"),
    const DropdownMenuItem(child: Text("Advanced"), value: "Advanced"),
  ];
  String selectedType = "Aerobic";
  List<DropdownMenuItem<String>> types = [
    const DropdownMenuItem(child: Text("Aerobic"), value: "Aerobic"),
    const DropdownMenuItem(child: Text("Strength"), value: "Strength"),
    const DropdownMenuItem(child: Text("Stretching"), value: "Stretching"),
    const DropdownMenuItem(child: Text("Balance"), value: "Balance"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Create An Exercise",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(10),
                child: Stepper(
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: details.onStepContinue,
                            child: step_index == 6
                                ? const Text('Submit')
                                : const Text('Next'),
                          ),
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: step_index == 0
                                ? const Text('')
                                : const Text('Back'),
                          ),
                        ],
                      );
                    },
                    currentStep: step_index,
                    onStepCancel: () {
                      if (step_index > 0) {
                        setState(() {
                          step_index -= 1;
                        });
                      }
                    },
                    onStepContinue: () {
                      if (step_index < 6) {
                        setState(() {
                          step_index += 1;
                        });
                      }
                      if (step_index == 6) {
                        submitExercise();
                      }
                    },
                    onStepTapped: (int index) {
                      setState(() {
                        step_index = index;
                      });
                    },
                    steps: [
                      Step(
                          title: Text("Write a title for the exercise :"),
                          content: TextField(
                            controller: titleController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9a-zA-Z ]")),
                            ],
                          )),
                      Step(
                          title: Text("Pick a difficulty for the exercise :"),
                          content: DropdownButton(
                              value: selectedDifficulty,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDifficulty = newValue!;
                                });
                              },
                              items: difficulties)),
                      Step(
                          title: Text(
                              "Enter the average duration in minutes for the exercise :"),
                          content: TextField(
                            controller: timeController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                          )),
                      Step(
                          title: Text("What does the exercise target ? :"),
                          content: DropdownButton(
                              value: selectedType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedType = newValue!;
                                });
                              },
                              items: types)),
                      Step(
                          title: Text(
                              "Upload an image that describes the exercise :"),
                          content: TextField(
                            controller: imageURLController,
                          )),
                      Step(
                          title: Text(
                              "Write a step-by-step tutorial for the exercise :"),
                          content: TextField(
                            controller: tutotialController,
                            maxLines: null,
                          )),
                      Step(
                          title: Text(
                              "Give a suggested number of sets/reps or any helpful tips for the exercise :"),
                          content: TextField(
                            controller: setsrepsController,
                            maxLines: null,
                          )),
                    ]),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
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
              heroTag: "createexerciseexitbtn",
              child: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
    );
  }

  void submitExercise() {
    if (titleController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        tutotialController.text.isNotEmpty &&
        setsrepsController.text.isNotEmpty) {
      String title = titleController.text;
      int time = int.parse(timeController.text);
      String tutorial = tutotialController.text;
      String setsreps = setsrepsController.text;
      String difficulty = selectedDifficulty;
      String type = selectedType;
      Exercise newExercise = Exercise(
          id: "",
          title: title,
          difficulty: difficulty,
          time: time,
          type: type,
          tutorial: tutorial,
          setsreps: setsreps);
      print(newExercise);
      widget.callback(newExercise);
      Navigator.of(context).pop();
    }
  }
}
