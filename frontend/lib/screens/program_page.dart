import 'package:flutter/material.dart';

class ProgramPage extends StatefulWidget {
  ProgramPage({Key? key}) : super(key: key);

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text("Program Page!")));
  }
}
