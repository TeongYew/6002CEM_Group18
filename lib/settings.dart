import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Settings extends StatefulWidget {
  static String routeName = '/settings';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  int age = 0;
  double height = 0;
  double weight = 0;
  String goal = "";
  bool goalChanged = false;

  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  late User user;

  @override
  void initState() {
    super.initState();

    _fetchUser();
  }

  void _fetchUser() async {
    final User tempUser = await UserDatabase.instance.getUser();
    setState(() {
      user = tempUser;
      age = user.age;
      height = user.height;
      weight = user.weight;
      goal = user.goal;
    });
  }

  void updateUserDetails() async {

    // User updatedUser = User(
    //     name: user.name,
    //     age: age,
    //     weight: weight,
    //     height: height,
    //     goal: goal,
    //     targetCalories: user.targetCalories,
    //     currentCalories: user.currentCalories);

    //await UserDatabase.instance.updateUserTest(user, age, weight, height, goal);
    await UserDatabase.instance.updateUserDetails(user, age, weight, height, goal);

    if(goalChanged) {

      int calories;

      int bmr = (88.362 + (13.397 * weight) + (4.799 * height ) - (5.677 * age)).round() ;

      if (goal == "Lose Weight") {
        calories = (bmr * 0.85).round();
      } else if (goal == "Gain Weight") {
        calories = (bmr * 1.15).round();
      } else {
        calories = bmr;
      }

      await UserDatabase.instance.updateUserTargetCalories(user, calories);
    }

    setState(() {
      ageController.clear();
      heightController.clear();
      weightController.clear();
    });

    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('Age: $age', style: TextStyle(fontSize: 16),),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: ageController,
                    onChanged: (value) {
                      setState(() {
                        age = int.parse(value);
                      });
                    },
                    decoration: InputDecoration(hintText: 'Enter your age'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('Weight: $weight', style: TextStyle(fontSize: 16),),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: weightController,
                    onChanged: (value) {
                      setState(() {
                        weight = double.parse(value);
                      });
                    },
                    decoration: InputDecoration(hintText: 'Enter your weight'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('Height: $height', style: TextStyle(fontSize: 16),),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: heightController,
                    onChanged: (value) {
                      setState(() {
                        height = double.parse(value);
                      });
                    },
                    decoration: InputDecoration(hintText: 'Enter your height'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('Goals: $goal', style: TextStyle(fontSize: 16),),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: goal,
                      hintText: 'Select your goals'
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "Lose Weight",
                        child: Text("Lose Weight"),
                      ),
                      DropdownMenuItem(
                        value: "Gain Weight",
                        child: Text("Gain Weight"),
                      ),
                      DropdownMenuItem(
                        value: "Maintain Weight",
                        child: Text("Maintain Weight"),
                      ),
                    ],
                    onChanged: (value) {
                      goal = value!;
                      goalChanged = true;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Update the user's details in SQLite
                  updateUserDetails();
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:fitness_tracker_app/calorie_tracker.dart';
// import 'package:fitness_tracker_app/model/user.dart';
// import 'package:flutter/material.dart';
//
// class Settings extends StatefulWidget {
//   static String routeName = '/settings';
//   const Settings({Key? key}) : super(key: key);
//
//   @override
//   State<Settings> createState() => _SettingsState();
// }
//
// class _SettingsState extends State<Settings> {
//
//   String name = '';
//   int age = 0;
//   double height = 0;
//   double weight = 0;
//   String goal = '';
//   double targetCalories = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     User user = ModalRoute.of(context)!.settings.arguments as User;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Settings"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Your current goal is: ${user.goal}'),
//             SizedBox(height: 16),
//             Text('Your current height is: ${user.height}'),
//             SizedBox(height: 16),
//             Text('Your current weight is: ${user.weight}'),
//             SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 // Show the edit dialog.
//                 showDialog(
//                   context: context,
//                   builder: (context) => EditDialog(),
//                 );
//               },
//               child: Text("Edit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class EditDialog extends StatelessWidget {
//   const EditDialog({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Edit Settings'),
//       content: Form(
//         key: CalorieTracker().key,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Goal',
//               ),
//               keyboardType: TextInputType.text,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a goal';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 //CalorieTracker.of(context).fitnessGoal = value;
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Height (in cm)',
//               ),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a height';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 //CalorieTracker.of(context).height = double.parse(value!);
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Weight (in kg)',
//               ),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a weight';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 //CalorieTracker.of(context).weight = double.parse(value!);
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             //CalorieTracker().key.currentState.validate();
//             //CalorieTracker().key.currentState.save();
//             Navigator.pop(context);
//           },
//           child: Text('Save'),
//         ),
//       ],
//     );
//   }
// }
//
//
//
