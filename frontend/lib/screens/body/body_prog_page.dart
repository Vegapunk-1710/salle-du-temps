import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:frontend/models/body_prog_model.dart';
import 'package:frontend/screens/body/body_hero_page.dart';
import 'package:frontend/screens/body/create_body_prog_page.dart';

class BodyProgPage extends StatefulWidget {
  BodyProgPage({Key? key}) : super(key: key);

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
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bodyProgData.json');
    if (await file.exists()) {
      file.writeAsStringSync('');
      file.writeAsString(
          jsonEncode(progressions.map((p) => p.toJson()).toList()));
    }
  }

  getProgressions() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bodyProgData.json');
    final contents = await file.readAsString();
    try {
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
        child: Scrollbar(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (_, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BodyProgHero(progressions[index])));
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Hero(
                    tag: 'bodyproghero${progressions[index].id}',
                    child: Image.file(File(progressions[index].imagesPaths[0]),
                        errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Card(
                              elevation: 10, child: Icon(Icons.image)));
                    }, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            itemCount: progressions.length,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              heroTag: "bodyprogexitbtn",
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateBodyProgPage(callback)));
              },
              heroTag: "bodyprogcreatebtn",
              child: const Icon(Icons.create),
            ),
          ),
        ],
      ),
    );
  }
}
