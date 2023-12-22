import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/workout_page.dart';
import 'package:frontend/widgets/workout_card_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'jan',
      'feb',
      'mar',
      'april',
      'may',
      'jun',
      'july',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    String day = now.day.toString();
    String month = months[now.month - 1].toUpperCase();

    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello,",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 26)),
                      Text("Baher",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 26)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(day,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 26)),
                      Text(month,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 26)),
                    ],
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Today's Workout",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26)),
                SizedBox(height: 10,),
                WorkoutCard(
                    imageURL:
                        'https://prod-ne-cdn-media.puregym.com/media/819394/gym-workout-plan-for-gaining-muscle_header.jpg?quality=80',
                    title: "Workout 1",
                    desc:
                        "BlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaowBlingBlaowBlaow",
                    misc: "Ah waer khalto!?",
                    func: () {
                      if (kDebugMode) {
                        print("Workout 1's Start Button Clicked !");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WorkoutPage()),
                        );
                      }
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Stats",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26)),
                SizedBox(height: 10,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Week's total workouts : 0",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[800],
                          )),
                      Text("Month's total workouts : 0",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[800],
                          )),
                      Text("Year's total workouts : 0",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[800],
                          )),
                    ]),
              ],
            ),
          )
        ],
      )),
    );
  }
}
