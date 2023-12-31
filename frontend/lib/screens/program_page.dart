import 'package:flutter/material.dart';
import 'package:frontend/models/program_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/widgets/workout_card.dart';

class ProgramPage extends StatefulWidget {
  final Program program;
  ProgramPage({Key? key, required this.program}) : super(key: key);

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  int w_index = 0 ;
  late List<Workout> workouts;

  @override
  void initState() {
    workouts = Workout.db();
    workouts = workouts
        .where((w1) => widget.program.workouts.any((w2) => w1.id == w2))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.program.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("CREATOR : ${widget.program.createdBy}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14)),
                      Text(
                          "CREATED : ${widget.program.createdAt.difference(DateTime.now()).inDays} days ago",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Workouts",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
            SizedBox(
            height: MediaQuery.of(context).size.height / 3.1,
            child: PageView.builder(
              itemCount: workouts.length,
              controller:
                  PageController(viewportFraction: 0.9, keepPage: false),
              onPageChanged: (index) => setState(() => w_index = index),
              itemBuilder: (context, index) {
                return AnimatedPadding(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    padding: EdgeInsets.all(w_index == index ? 0.0 : 8.0),
                    child: WorkoutCard(
                      workout: workouts[w_index],
                    ));
              },
            ),
          ),
          ]),
        ),
      ),
    );
  }
}
