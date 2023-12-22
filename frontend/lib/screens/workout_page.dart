import 'package:flutter/material.dart';
import 'package:frontend/widgets/workout_card_widget.dart';

class WorkoutPage extends StatefulWidget {
  WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
          Image.network(
              'https://prod-ne-cdn-media.puregym.com/media/819394/gym-workout-plan-for-gaining-muscle_header.jpg?quality=80'),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("WORKOUT TITLE",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                Text("WORKOUT DIFF/TIME/MISC",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18))
              ],
            ),
          ),
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Description",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Exercises",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22))),
          SizedBox(
            height: MediaQuery.of(context).size.height/3, 
            child: PageView.builder(
              itemCount: 10,
              controller: PageController(viewportFraction: 0.8),
              onPageChanged: (index) => setState(() => _index = index),
              itemBuilder: (context, index) {
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  padding: EdgeInsets.all(_index == index ? 0.0 : 8.0),
                  child: WorkoutCard(
                      imageURL:
                          "https://info.totalwellnesshealth.com/hubfs/HealthBenefitsFitness.png",
                      title: "Exer.$_index",
                      desc: "desc",
                      misc: "misc",
                      func: () {}),
                );
              },
            ),
          ),
        ]
        )
        )
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30,0,0,0),
            child: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              heroTag: "workoutexitbtn",
              child: const Icon(Icons.exit_to_app),
            ),
          ),
          FloatingActionButton(
            onPressed: (){
              print("Workout Started !!");
            },
            heroTag: "workoutstartbtn",
            child: const Text("GO"),
          )
        ],
      ),
    );
  }
}
