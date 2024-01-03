import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/workout_model.dart';

class CreateWorkoutPage extends StatefulWidget {
  final Function(Workout createdWorkout) create_callback;
  CreateWorkoutPage(this.create_callback, {Key? key}) : super(key: key);

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  int step_index = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String selectedDifficulty = "Beginner";
  List<DropdownMenuItem<String>> difficulties = [
    DropdownMenuItem(
        value: Difficulty.Beginner.name, child: const Text("Beginner")),
    DropdownMenuItem(
        value: Difficulty.Intermediate.name, child: const Text("Intermediate")),
    DropdownMenuItem(
        value: Difficulty.Advanced.name, child: const Text("Advanced")),
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
              child: Text("Create A Workout",
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
                            child: step_index == 4
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
                      if (step_index < 4) {
                        setState(() {
                          step_index += 1;
                        });
                      }
                      if (step_index == 4) {
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
                          title: const Text("Write a title for the workout :"),
                          content: TextField(
                            controller: titleController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9a-zA-Z ]")),
                            ],
                          )),
                      Step(
                          title:
                              const Text("Pick a difficulty for the workout :"),
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
                              "Enter the average duration in minutes for the workout :"),
                          content: TextField(
                            controller: timeController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                          )),
                      Step(
                          title: const Text(
                              "Upload an image that describes the workout :"),
                          content: TextField(
                            controller: imageURLController,
                          )),
                      Step(
                          title: const Text(
                              "Write a description for the workout :"),
                          content: TextField(
                            controller: descController,
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
              heroTag: "createworkoutexitbtn",
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
        descController.text.isNotEmpty) {
      String title = titleController.text;
      int time = int.parse(timeController.text);
      String desc = descController.text;
      var difficulty = Workout.translateStringToDifficulty(selectedDifficulty);
      String? imageURL = imageURLController.text;
      Workout createdWorkout = Workout(
          id: UniqueKey().toString(),
          imageURL: imageURL,
          createdBy: "Baher",
          createdAt: DateTime.now(),
          title: title,
          difficulty: difficulty,
          time: time,
          description: desc,
          exercises: [],
          days: [],
          progression: [],
          );
      widget.create_callback(createdWorkout);
      Navigator.of(context).pop();
    }
  }
}
