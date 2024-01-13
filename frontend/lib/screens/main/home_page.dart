import 'package:flutter/material.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/screens/body/body_prog_page.dart';
import 'package:frontend/widgets/workout_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  late String dayName;
  late Workout? todayWorkout;
  late List<Workout> workouts;
  late AppState appState;
  DateTime now = DateTime.now();
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  loadingCallback(bool isFinished) {
    setState(() {
      loading = isFinished;
      if (!loading) {
        workouts = appState.user.workouts;
        if (workouts.isEmpty) {
          todayWorkout = null;
        } else {
          todayWorkout = workouts[0];
        }
      }
    });
  }

  @override
  void initState() {
    appState = AppState("vegapunk", "rony123");
    appState.getUser(loadingCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dayName = daysOfWeek[now.weekday - 1];

    return SafeArea(
        child: Center(
            child: loading
                ? const RefreshProgressIndicator()
                : ListView(
                    children: [
                      FittedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Let's Grind, ${appState.user.name}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(
                                  width: 100,
                                ),
                                Text(
                                    "${DateTime.now().toIso8601String().substring(0, 10).split("-")[1]}/${DateTime.now().toIso8601String().substring(0, 10).split("-")[2]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            )),
                      ),
                      Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("$dayName's Workout",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22))),
                          todayWorkout == null
                              ? const Center(
                                  child: Text("No Workouts For Today"),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2.7,
                                  child: WorkoutCard(
                                    workout: todayWorkout!,
                                  )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BodyProgPage()));
                                  },
                                  child: const Card(
                                    elevation: 10,
                                    child: Center(
                                        child: Text("Body Transformation")),
                                  )),
                              const Card(
                                elevation: 10,
                                child: Center(child: Text("Statistics")),
                              ),
                            ]),
                      ),
                    ],
                  )));
  }
}
