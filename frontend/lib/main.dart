import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/screens/body/body_prog_page.dart';
import 'package:frontend/screens/main/home_page.dart';
import 'package:frontend/screens/main/workouts_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      _themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
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
  bool userCredFound = false;
  AppState appState = AppState();
  late ThemeMode themeMode;
  late SharedPreferences prefs;

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
    initUser();
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    setState(() {
      themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    });
    super.initState();
  }

  initUser() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') == null ||
        prefs.getString('password') == null) {
      setState(() {
        userCredFound = false;
        loading = true;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoadingPage(appState, loginCallback)));
    } else {
      bool isLoading = true;
      try {
        isLoading = await appState.getUser(
            prefs.getString('username')!, prefs.getString('password')!);
        setState(() {
          userCredFound = true;
          loading = isLoading;
        });
      } catch (e) {
        prefs.clear();
        setState(() {
          userCredFound = false;
          loading = true;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoadingPage(appState, loginCallback)));
      }
    }
  }

  loginCallback(String username, String password) async {
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    setState(() {
      userCredFound = true;
      loading = false;
    });
  }

  void refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !userCredFound && loading
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
      floatingActionButton: _selectedIndex == 0
          ? Row(
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Sign Out?"),
                          content:
                              const Text("Are you sure you want to sign out?"),
                          actions: [
                            TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("No")),
                            TextButton(
                              child: const Text("Yes"),
                              onPressed: () async {
                                final directory =
                                    await getApplicationCacheDirectory();
                                final file =
                                    File('${directory.path}/bodyProgData.json');
                                if (await file.exists()) {
                                  await file.delete();
                                }
                                setState(() {
                                  prefs.clear();
                                  appState = AppState();
                                });
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoadingPage(
                                            appState, loginCallback)));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  heroTag: "homesettingsbtn",
                  child: const Icon(Icons.door_back_door),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
