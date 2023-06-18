import 'package:fitness_tracker_app/calorie_counter.dart';
import 'package:fitness_tracker_app/calorie_tracker.dart';
import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:fitness_tracker_app/running_tracker_page.dart';
import 'package:fitness_tracker_app/settings.dart';
import 'package:fitness_tracker_app/step_counter.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  static String routeName = '/mainMenu';
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late User user;
  late bool existUser = false;

  @override
  void initState() {
    super.initState();

    //get the user information
    refreshUser();
  }

  @override
  void dispose() {
    UserDatabase.instance.close();

    super.dispose();
  }

  Future refreshUser() async {
    setState(() {
    });

    //check if there is a user in the db
    this.existUser = await UserDatabase.instance.checkUser();

    //if user exists, then get the user information
    if (existUser) {
      this.user = await UserDatabase.instance.getUser();
    } else {
      this.existUser = false;
    }

    //refresh the page
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness App"),
      ),
      body: FractionallySizedBox(
        alignment: Alignment.center,
        heightFactor: 1.0,
        widthFactor: 1.0,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              //get the user information and refresh the page
              refreshUser();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      existUser
                          ? "Welcome back, ${user.name}!"
                          : "Register your details in the Calorie Counter page.",
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      existUser
                          ? "You have ${user.targetCalories - user.currentCalories} calories left today."
                          : "Set your target calories.",
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: 50,
                      crossAxisSpacing: 20,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                //if user already exists, notify the user to update their information at Settings page
                                //else, navigate to Calorie Counter page
                                if (existUser) {
                                  //notify user to update their information at Settings page
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Update your details in Settings."),
                                    ),
                                  );
                                } else {
                                  //navigate to Calorie Counter page
                                  Navigator.of(context).pushNamed(CalorieCounter.routeName);
                                }
                              },
                              icon: const Icon(Icons.calculate),
                              iconSize: 48,
                              color: Colors.blue,
                              tooltip: "Calorie Counter",
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Calorie Counter",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                //if user exists, navigate to Calorie Tracker
                                //else, display a message to notify the user to go to Calorie Counter page
                                if (existUser) {
                                  //navigate to Calorie Tracker
                                  Navigator.of(context).pushNamed(CalorieTracker.routeName, arguments: user);
                                } else {
                                  //notify the user to go to Calorie Counter page
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Go to Calorie Counter."),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.timeline),
                              iconSize: 48,
                              color: Colors.orange,
                              tooltip: "Calorie Tracker",
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Calorie Tracker",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(RunningTrackerPage.routeName);
                              },
                              icon: const Icon(Icons.directions_run),
                              iconSize: 48,
                              color: Colors.purple,
                              tooltip: "Running Tracker",
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Running Tracker",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(StepCounterPage.routeName);
                              },
                              icon: const Icon(Icons.directions_walk),
                              iconSize: 48,
                              color: Colors.yellow,
                              tooltip: "Step Counter",
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Step Counter",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                //if user exists, navigate to Settings page
                                //else, display a message to notify the user to go to Calorie Counter page
                                if (existUser) {
                                  //navigate to Settings page
                                  Navigator.of(context).pushNamed(Settings.routeName, arguments: user);
                                } else {
                                  //display a message to notify the user to go to Calorie Counter page
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Go to Calorie Counter."),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.settings),
                              iconSize: 48,
                              color: Colors.green,
                              tooltip: "Settings",
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Settings",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                //refresh the page
                                setState(() {
                                  //delete all users and foods in the app
                                  //set existUser to false
                                  UserDatabase.instance.deleteAllUser();
                                  UserDatabase.instance.deleteAllFood();
                                  existUser = false;
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              iconSize: 48,
                              color: Colors.red,
                              tooltip: "Reset App",
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Reset App",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

