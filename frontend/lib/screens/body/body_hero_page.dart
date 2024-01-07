import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/body_prog_model.dart';

class BodyProgHero extends StatefulWidget {
  final BodyProgression progression;
  BodyProgHero(this.progression, {Key? key}) : super(key: key);

  @override
  State<BodyProgHero> createState() => _BodyProgHeroState();
}

class _BodyProgHeroState extends State<BodyProgHero> {
  int page_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
            Hero(
                tag: 'bodyproghero${widget.progression.id}',
                child: PageView.builder(
                  itemCount: widget.progression.imagesPaths.length,
                  onPageChanged: (index) => setState(() {
                    page_index = index;
                  }),
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      child: Image.file(
                        File(widget.progression.imagesPaths[index]),
                        errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Card(
                              elevation: 10, child: Icon(Icons.image)));
                    },
                          fit: BoxFit.cover),
                    );
                  },
                )),
            SafeArea(
              child: Column(children: [
                HeroText("${page_index+1}/${widget.progression.imagesPaths.length}", 25)
              ],),
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                HeroText(widget.progression.createdAt.toIso8601String().split("T").first, 25),
                HeroText("${widget.progression.currentWeight} lbs" , 25),
              ],),
            )
      ]),
    );
  }

  Stack HeroText(String text, double? size) {
    return Stack(
children: <Widget>[
  Text(
    text,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black,
    ),
  ),
  Text(
     text,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: Colors.grey[300],
    ),
  ),
],
);
  }
}
