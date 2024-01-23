import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/state_model.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:frontend/models/body_prog_model.dart';
import 'package:frontend/screens/body/body_hero_page.dart';
import 'package:frontend/screens/body/create_body_prog_page.dart';

class BodyProgPage extends StatefulWidget {
  final AppState appState;
  BodyProgPage(this.appState, {Key? key}) : super(key: key);

  @override
  State<BodyProgPage> createState() => _BodyProgPageState();
}

class _BodyProgPageState extends State<BodyProgPage> {
  List<BodyProgression> progressions = [];

  @override
  initState() {
    getProgressions();
    super.initState();
  }

  saveProgression() async {
    final directory = await getApplicationCacheDirectory();
    final file = File('${directory.path}/bodyProgData.json');
    if (await file.exists()) {
      file.writeAsStringSync('');
      file.writeAsString(
          jsonEncode(progressions.map((p) => p.toJson()).toList()));
    }
  }

  getProgressions() async {
    final directory = await getApplicationCacheDirectory();
    final file = File('${directory.path}/bodyProgData.json');
    if (!await file.exists()) {
      await file.create();
    }
    try {
      final contents = await file.readAsString();
      Iterable p = json.decode(contents);
      setState(() {
        progressions = List<BodyProgression>.from(
            p.map((model) => BodyProgression.fromJson(model)));
      });
    } catch (e) {
      if (kDebugMode) {
        print("Body Progressions File is empty.");
      }
    }
  }

  void deleteProgression() {
    if (this.mounted) {
      setState(() {
        BodyProgression deletedProg = progressions.removeLast();
        saveProgression();
        getProgressions();
        var snackBar = SnackBar(
          content: Text(
              'Deleted Body Progression : ${deletedProg.createdAt.toIso8601String().split("T").first}'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              if (this.mounted) {
                setState(() {
                  progressions.add(deletedProg);
                  saveProgression();
                  getProgressions();
                });
              }
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  callback(BodyProgression progression) {
    setState(() {
      progressions.add(progression);
      saveProgression();
      getProgressions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: progressions.isEmpty
            ? const Center(
                child: ListTile(
                    title: Text('No Body Progressions Yet.'),
                    subtitle: Text(
                        '(Click the "pen" button to create a body progression)')))
            : Scrollbar(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (_, index) => index < progressions.length
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BodyProgHero(progressions[index],widget.appState.user.startingWeight)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Hero(
                                tag: 'bodyproghero${progressions[index].id}',
                                child: Image.file(
                                    File(progressions[index].imagesPaths[0]),
                                    errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Card(
                                          elevation: 10,
                                          child: Icon(Icons.image)));
                                }, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        )
                      : progressions.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: () {
                                handleDelete(context);
                              },
                              icon: const Icon(Icons.delete_forever)),
                  itemCount: progressions.length + 1,
                ),
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateBodyProgPage(callback)));
            },
            heroTag: "bodyprogcreatebtn",
            child: const Icon(Icons.create),
          ),
        ],
      ),
    );
  }

  Future<dynamic> handleDelete(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Delete this progression ?"),
        content: const Text(
            "Are you sure you want to delete the last progression ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text("No")),
          TextButton(
              onPressed: () {
                deleteProgression();
                Navigator.pop(context, 'OK');
              },
              child: const Text("Yes")),
        ],
      ),
    );
  }
}
