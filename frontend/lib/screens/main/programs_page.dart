import 'package:flutter/material.dart';
import 'package:frontend/models/program_model.dart';
import 'package:frontend/screens/program_page.dart';

class ProgramsPage extends StatefulWidget {
  ProgramsPage({Key? key}) : super(key: key);

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  late List<Program> myPrograms;

  @override
  void initState() {
    String creator = "Rony";
    List<Program> programs = Program.db();
    myPrograms = programs.where((p) => p.createdBy == creator).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: myPrograms.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            if (index == myPrograms.length) {
              return GestureDetector(
                onTap: (){},
                child: Card(
                  elevation: 10,
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Create New Program",
                            style: Theme.of(context).textTheme.bodyLarge),
                      const Icon(Icons.create),
                    ],
                  )),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProgramPage(program:myPrograms[index])));
                },
                child: Card(
                  elevation: 10,
                  child: GridTile(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Program ${index+1}",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Column(
                          children: [
                            Text(myPrograms[index].title,
                                style: Theme.of(context).textTheme.bodyLarge),
                            Text("By ${myPrograms[index].createdBy}",
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        Text("Created ${myPrograms[index].createdAt.difference(DateTime.now()).inDays} days ago",
                          style: Theme.of(context).textTheme.bodySmall),
                      ],
                    )),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
