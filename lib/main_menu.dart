import 'package:fitness_tracker_app/calorie_counter.dart';
import 'package:fitness_tracker_app/calorie_tracker.dart';
import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/user.dart';
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
    } else
      () {
        this.existUser = false;
      };

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness App"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  existUser
                      ? "Welcome back, ${user.name}!"
                      : "Register your details in the Calorie Counter page.",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30),
                Text(
                  existUser
                      ? "You have ${user.targetCalories - user.currentCalories} calories left today."
                      : "Set your target calories.",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (existUser) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Update your details in Settings."),
                        ),
                      );
                    } else {
                      Navigator.of(context).pushNamed(CalorieCounter.routeName);
                    }
                  },
                  child: Text("Calorie Counter"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (existUser) {
                      Navigator.of(context).pushNamed(CalorieTracker.routeName, arguments: user);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Go to Calorie Counter."),
                        ),
                      );
                    }
                  },
                  child: Text("Calorie Tracker"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (existUser) {
                      Navigator.of(context).pushNamed(Settings.routeName, arguments: user);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Go to Calorie Counter."),
                        ),
                      );
                    }
                  },
                  child: Text("Settings"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      UserDatabase.instance.deleteAllUser();
                      UserDatabase.instance.deleteAllFood();
                      existUser = false;
                    });
                  },
                  child: Text("Reset App"),
                ),
                SizedBox(height: 50),
              ],
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