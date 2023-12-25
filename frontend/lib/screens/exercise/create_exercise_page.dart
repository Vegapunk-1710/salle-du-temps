import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateExercise extends StatefulWidget {
  CreateExercise({Key? key}) : super(key: key);

  @override
  State<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  int step_index = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Create An Exercise",
                        style:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: PageView.builder(
                itemCount: 3,
                controller:
                PageController(viewportFraction: 0.8, keepPage: false),
                onPageChanged: (index) => setState(() => step_index = index),
                itemBuilder: (context, index) {
                  return AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      padding: EdgeInsets.all(step_index == index ? 0.0 : 8.0),
                      child: FirstStep()
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}

class FirstStep extends StatelessWidget {
  const FirstStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: FittedBox(
                child: Text("1 - Enter a title for the exercise",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 22)),
              ),
            ),
            Padding(
             padding: const EdgeInsets.all(8.0),
             child: SizedBox(
               height: MediaQuery.of(context).size.height / 20,
               width: MediaQuery.of(context).size.width / 2,
               child: const TextField(
                 textAlign: TextAlign.center, 
                 keyboardType: TextInputType.name,
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.all(Radius.circular(20))),
                   hintText: "Title",
                 ),
               ),
             ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: FittedBox(
                child: Text("1 - Enter a title for the exercise",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 22)),
              ),
            ),
            Padding(
             padding: const EdgeInsets.all(8.0),
             child: SizedBox(
               height: MediaQuery.of(context).size.height / 20,
               width: MediaQuery.of(context).size.width / 2,
               child: const TextField(
                 textAlign: TextAlign.center, 
                 keyboardType: TextInputType.name,
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.all(Radius.circular(20))),
                   hintText: "Title",
                 ),
               ),
             ),
            ),
          ],
        ),
      ),
    );
  }
}