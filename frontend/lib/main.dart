import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/screens/body/body_prog_page.dart';
import 'package:frontend/screens/main/home_page.dart';
import 'package:frontend/screens/main/settings_page.dart';
import 'package:frontend/screens/main/workouts_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Salle Du Temps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        //black bg
        //red buttons
        //white text
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  bool loading = true;
  late AppState appState;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages = <Widget>[
    HomePage(appState, refreshCallback),
    WorkoutsPage(appState, refreshCallback),
    BodyProgPage(),
  ];

  @override
  void initState() {
    initUser();
    super.initState();
  }

  Future<void> initUser() async {
    appState = AppState("tarzan", "rony123");
    bool isLoading = await appState.getUser();
    setState(() {
      loading = isLoading;
    });
  }

  void refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: const RefreshProgressIndicator())
          : _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          enableFeedback: true,
          selectedItemColor: Theme.of(context).colorScheme.onBackground,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.sports_gymnastics), label: "Workouts"),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart),
              label: "Body Progression",
            ),
          ]),
    );
  }
}
