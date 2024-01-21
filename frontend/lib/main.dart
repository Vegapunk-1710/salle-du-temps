import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/screens/body/body_prog_page.dart';
import 'package:frontend/screens/main/home_page.dart';
import 'package:frontend/screens/main/settings_page.dart';
import 'package:frontend/screens/main/workouts_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ThemeMode _themeMode;
  @override
  void initState() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    setState(() {
      _themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    });
    super.initState();
  }

  ThemeMode toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
    return _themeMode;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Salle Du Temps',
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
            primary: Colors.deepOrange,
          )),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.deepPurple,
          )),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: LandingPage(toggleTheme),
    );
  }
}

class LandingPage extends StatefulWidget {
  final Function toggleTheme;
  LandingPage(this.toggleTheme, {super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  bool loading = true;
  late AppState appState;
  late ThemeMode themeMode;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages = <Widget>[
    HomePage(
      appState,
      refreshCallback,
    ),
    WorkoutsPage(appState, refreshCallback),
    BodyProgPage(),
  ];

  @override
  void initState() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    setState(() {
     themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;  
    });
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
          ? const Center(child: RefreshProgressIndicator())
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
      floatingActionButton: _selectedIndex == 0? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  themeMode = widget.toggleTheme();
                });
              },
              heroTag: "homedarkmodebtn",
              child: Icon(themeMode == ThemeMode.light
                  ? Icons.sunny_snowing
                  : Icons.sunny),
            ),
          ),
          FloatingActionButton(
              onPressed: () {
              },
              heroTag: "homesettingsbtn",
              child: const Icon(Icons.settings),
            ),
        ],
      ) : const SizedBox(),
    );
  }
}
