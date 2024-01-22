import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/state_model.dart';
import 'package:frontend/models/user_model.dart';

class LoadingPage extends StatefulWidget {
  final AppState appState;
  bool wantsLogin = true;
  bool loading = false;

  final Function loginCallback;
  final Function signUpCallback;
  LoadingPage(this.appState, this.loginCallback, this.signUpCallback,
      {Key? key})
      : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  DateTime selectedDate = DateTime.parse("2000-01-01");
  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController signUsernameController = TextEditingController();
  TextEditingController signPasswordController = TextEditingController();
  TextEditingController signNameController = TextEditingController();
  TextEditingController signWeightController = TextEditingController();
  TextEditingController signHeightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Card(
              elevation: 10,
              child: widget.wantsLogin
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Flexible(
                            child: Text("💪🏽🏋🏽😈",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 10))),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            controller: loginUsernameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                hintText: 'Enter your username'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                          child: TextField(
                            obscureText: true,
                            controller: loginPasswordController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter your password'),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Text("Login"),
                              onPressed: () {
                                handleLogin(context);
                              },
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.wantsLogin = false;
                                  });
                                },
                                child:
                                    const Text("Not Signed Up Yet? Click Here"))
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Flexible(
                            child: Text("Sign Up 📝",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                ))),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            controller: signUsernameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                hintText: 'Enter a username for login'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                          child: TextField(
                            controller: signPasswordController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter a password for login'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                          child: TextField(
                            controller: signNameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                                hintText:
                                    'Enter the name the app will call you (Everyone will see this name!)'),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]")),
                              LengthLimitingTextInputFormatter(20),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: const Text('Select Date Of Birth'),
                                ),
                                Text(selectedDate.toString().split(" ").first)
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                          child: TextField(
                            controller: signWeightController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Starting Weight',
                                hintText: 'Enter your weight in lbs'),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                          child: TextField(
                            controller: signHeightController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Height',
                                hintText: 'Enter your height in cm'),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: widget.loading ? const RefreshProgressIndicator() : Text("Sign Up"),
                              onPressed: () {
                                handleSignUp(context);
                              },
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.wantsLogin = true;
                                  });
                                },
                                child: const Text("Existing User? Click Here"))
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void handleLogin(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> handleSignUp(BuildContext context) async {
    String username = signUsernameController.text;
    String password = signPasswordController.text;
    String name = signNameController.text;
    String dob = selectedDate.toString().split(" ").first;
    String createdAt = DateTime.now().toString().split(" ").first;
    String updatedAt = createdAt;
    int? weight = int.tryParse(signWeightController.text);
    int? height = int.tryParse(signHeightController.text);
    if (username.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        dob.isEmpty ||
        height == null ||
        weight == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Fields may be empty or height/weight might not be numbers."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        widget.loading = true;
      });
      try {
        User user = await widget.appState.signUp(username, password, name, dob,
            createdAt, updatedAt, weight, height);
        widget.signUpCallback(username, password);
        setState(() {
        widget.loading = false;
      });
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
        widget.loading = false;
      });
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
