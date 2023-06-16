import 'package:fitness_tracker_app/calorie_counter.dart';
import 'package:fitness_tracker_app/calorie_tracker.dart';
import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:fitness_tracker_app/running_tracker_page.dart';
import 'package:fitness_tracker_app/settings.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshUser();
  }

  @override
  void dispose() {
    UserDatabase.instance.close();

    super.dispose();
  }

  Future refreshUser() async {
    setState(() {
      isLoading = true;
    });

    this.existUser = await UserDatabase.instance.checkUser();

    if (existUser) {
      this.user = await UserDatabase.instance.getUser();
    } else {
      this.existUser = false;
    }

    setState(() {
      isLoading = false;
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
                                if (existUser) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Update your details in Settings."),
                                    ),
                                  );
                                } else {
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
                                if (existUser) {
                                  Navigator.of(context).pushNamed(CalorieTracker.routeName, arguments: user);
                                } else {
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
                                Navigator.of(context).pushNamed(RunningTrackerPage.routeName);
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
                                if (existUser) {
                                  Navigator.of(context).pushNamed(Settings.routeName, arguments: user);
                                } else {
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
                                setState(() {
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



//@override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Fitness App"),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {refreshUser();},
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(existUser
//                         ? "Welcome back ${user.name}."
//                         : "Please register your details by heading over to the Calorie Counter page."),
//                     SizedBox(height: 20),
//                     Text(existUser
//                         ? "Your have ${(user.targetCalories - user.currentCalories).toString()} left for today."
//                         : "Your target calories are not set yet."),
//                     SizedBox(height: 20),
//                     TextButton(
//                       onPressed: () {
//                         if (existUser) {
//                           // Display the consumed calories to the user.
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("To update your details, head over to Settings."),
//                             ),
//                           );
//                         } else {
//                           Navigator.of(context).pushNamed(CalorieCounter.routeName);
//                         }
//                       },
//                       child: Text("Calorie Counter"),
//                     ),
//                     SizedBox(height: 10),
//                     TextButton(
//                       onPressed: () {
//                         if (existUser) {
//                           Navigator.of(context)
//                               .pushNamed(CalorieTracker.routeName, arguments: user);
//                         } else {
//                           // Display the consumed calories to the user.
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Head over to Calorie Counter."),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text("Calorie Tracker"),
//                     ),
//                     SizedBox(height: 10),
//                     TextButton(
//                       onPressed: () {
//                         if (existUser) {
//                           Navigator.of(context)
//                               .pushNamed(Settings.routeName, arguments: user);
//                         } else {
//                           // Display the consumed calories to the user.
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Head over to Calorie Counter."),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text("Settings"),
//                     ),
//                     SizedBox(height: 10),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           UserDatabase.instance.deleteAllUser();
//                           UserDatabase.instance.deleteAllFood();
//                           existUser = false;
//                         });
//                       },
//                       child: Text("Reset App"),
//                     ),
//                   ],
//                 ),
//               ),
//         ),
//       ),
//     );
//   }