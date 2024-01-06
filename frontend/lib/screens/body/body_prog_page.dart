import 'dart:convert';
import 'dart:io';
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
    loadBodyProgData();
    super.initState();
  }

  Future<List<BodyProgression>> loadBodyProgData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bodyProgData.json');
    print(file.path);
    if (!await file.exists()) {
      await file.create();
      return [];
    } else {
      // file.writeAsStringSync('');
      final contents = await file.readAsString();
      print("Getting Contents :" + contents);
      final content = json.decode(contents);
      setState(() {
        print(BodyProgression.fromJson(content));
        progressions.add(BodyProgression.fromJson(content));
      });
      return [];
      // try {
      //   final contents = await file.readAsString();
      //   print("Printing Contents :" + contents);
      //   Iterable content = json.decode(contents);
      //   progressions = List<BodyProgression>.from(
      //       content.map((model) => BodyProgression.fromJson(model)));
      //   return progressions;
      // } catch (e) {
      //   return [];
      // }
    }
  }

  saveBodyProgData(BodyProgression progression) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bodyProgData.json');
    if (await file.exists()) {
      file.writeAsString(json.encode(progression.toJson()));
    }
  }

  readBodyProgData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bodyProgData.json');
    final contents = await file.readAsString();
    print("Reading Contents :" + contents);
    final content = json.decode(contents);
    final p = BodyProgression.fromJson(content);
    print(p);
  }

  callback(BodyProgression progression) {
    setState(() {
      progressions.add(progression);
      saveBodyProgData(progression);
      readBodyProgData();
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
                    tag: 'bodyproghero' + progressions[index].id,
                    child: Image.file(File(progressions[index].imagesPaths[0]),
                        //     errorBuilder: (context, error, stackTrace) {
                        //   return SizedBox(
                        //       width: MediaQuery.of(context).size.width,
                        //       child: const Card(
                        //           elevation: 10, child: Icon(Icons.image)));
                        // },
                        fit: BoxFit.cover),
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
