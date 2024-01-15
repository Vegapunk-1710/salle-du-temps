import 'package:flutter/material.dart';
import 'package:frontend/models/state_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(AppState appState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text("Settings Page!")
      ),
    );
  }
}