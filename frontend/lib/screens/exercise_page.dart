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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Image.network(
                'https://info.totalwellnesshealth.com/hubfs/HealthBenefitsFitness.png'),
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
                      Text("TIME : ${widget.exercise.time}",
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
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(widget.exercise.tutorial,style:
                          const TextStyle(fontWeight: FontWeight.w400, fontSize: 16))),
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Progression",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
            Card(
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.exercise.progression.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(widget.exercise.progression[index].$1),
                            const Icon(Icons.arrow_right),
                            Text("${widget.exercise.progression[index].$2} lbs") 
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50,12,5,5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/20,
                    width: MediaQuery.of(context).size.width/2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                         FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: 'New Weight (in lbs)',
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                }, icon: const Icon(Icons.add))
              ],
            ),
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
