import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/screens/body/create_body_prog_page.dart';

class BodyProgPage extends StatefulWidget {
  BodyProgPage({Key? key}) : super(key: key);

  @override
  State<BodyProgPage> createState() => _BodyProgPageState();
}

class _BodyProgPageState extends State<BodyProgPage> {
  List<String> paths = [];
  
  callback(String? addedPath) {
    setState(() {
      paths.add(addedPath!);
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
            itemBuilder: (_, index) =>
                Image.file(File(paths[index]), fit: BoxFit.cover),
            itemCount: paths.length,
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
