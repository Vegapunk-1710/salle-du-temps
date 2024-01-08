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
    DropdownMenuItem(value: Difficulty.Beginner.name, child: const Text("Beginner")),
    DropdownMenuItem(
        value: Difficulty.Intermediate.name,
        child: const Text("Intermediate")),
    DropdownMenuItem(value: Difficulty.Advanced.name, child: const Text("Advanced")),
  ];
  String selectedType = "Aerobic";
  List<DropdownMenuItem<String>> types = [
    DropdownMenuItem(value: Type.Aerobic.name, child: const Text("Aerobic")),
    DropdownMenuItem(value: Type.Strength.name, child: const Text("Strength")),
    DropdownMenuItem(value: Type.Stretching.name, child: const Text("Stretching")),
    DropdownMenuItem(value: Type.Balance.name, child: const Text("Balance")),
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
                margin: const EdgeInsets.all(10),
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
                          title: const Text("Write a title for the exercise :"),
                          content: TextField(
                            controller: titleController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9a-zA-Z ]")),
                            ],
                          )),
                      Step(
                          title: const Text("Pick a difficulty for the exercise :"),
                          content: DropdownButton(
                              value: selectedDifficulty,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDifficulty = newValue!;
                                });
                              },
                              items: difficulties)),
                      Step(
                          title: const Text(
                              "Enter the average duration in minutes for the exercise :"),
                          content: TextField(
                            controller: timeController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                          )),
                      Step(
                          title: const Text("What does the exercise target ? :"),
                          content: DropdownButton(
                              value: selectedType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedType = newValue!;
                                });
                              },
                              items: types)),
                      Step(
                          title: const Text(
                              "Upload an image that describes the exercise :"),
                          content: TextField(
                            controller: imageURLController,
                          )),
                      Step(
                          title: const Text(
                              "Write a step-by-step tutorial for the exercise :"),
                          content: TextField(
                            controller: tutotialController,
                            maxLines: null,
                          )),
                      Step(
                          title: const Text(
                              "Give a suggested number of sets/reps or any helpful tips for the exercise :"),
                          content: TextField(
                            controller: setsrepsController,
                            maxLines: null,
                          )),
                    ]),
              ),
            ),
            const SizedBox(
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
              child: const  Icon(Icons.arrow_back),
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
      var difficulty = Exercise.translateStringToDifficulty(selectedDifficulty);
      var type = Exercise.translateStringToType(selectedType);
      String? imageURL = imageURLController.text;
      Exercise newExercise = Exercise(
          id: UniqueKey().toString(),
          title: title,
          imageURL: imageURL,
          createdBy: "Rony",
          createdAt: DateTime.now(),
          difficulty: difficulty,
          time: time,
          type: type,
          tutorial: tutorial,
          setsreps: setsreps,
          progression: []
          );
      widget.callback(newExercise);
      Navigator.of(context).pop();
    }
  }
}
