import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';

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
    await UserDatabase.instance.updateUserDetails(user, age, weight, height, goal);

    int calories;

    int bmr = (88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)).round();

    if (goal == "Lose Weight") {
      calories = (bmr * 0.85).round();
    } else if (goal == "Gain Weight") {
      calories = (bmr * 1.15).round();
    } else {
      calories = bmr;
    }

    await UserDatabase.instance.updateUserTargetCalories(user, calories);

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Age'),
                trailing: Text(
                  '$age',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Weight'),
                trailing: Text(
                  '$weight',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Icon(Icons.height),
                title: Text('Height'),
                trailing: Text(
                  '$height',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Icon(Icons.flag),
                title: Text('Goal'),
                trailing: Text(
                  goal,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Update Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: ageController,
                onChanged: (value) {
                  setState(() {
                    age = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: weightController,
                onChanged: (value) {
                  setState(() {
                    weight = double.parse(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Weight',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: heightController,
                onChanged: (value) {
                  setState(() {
                    height = double.parse(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Height',
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Goal',
                  hintText: 'Select your goal',
                ),
                value: goal,
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
                  setState(() {
                    goal = value.toString();
                    goalChanged = true;
                  });
                },
              ),
              SizedBox(height: 20.0),
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
      ),
    );
  }

}

//@override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Personal Details',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             buildInputRow('Age ${user.age}', ageController, TextInputType.number, (value) {
//               setState(() {
//                 age = int.tryParse(value) ?? 0;
//               });
//             }),
//             SizedBox(height: 10),
//             buildInputRow('Weight (kg)', weightController, TextInputType.number, (value) {
//               setState(() {
//                 weight = double.tryParse(value) ?? 0;
//               });
//             }),
//             SizedBox(height: 10),
//             buildInputRow('Height (cm)', heightController, TextInputType.number, (value) {
//               setState(() {
//                 height = double.tryParse(value) ?? 0;
//               });
//             }),
//             SizedBox(height: 20),
//             Text(
//               'Goals',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             DropdownButtonFormField(
//               decoration: InputDecoration(
//                 labelText: 'Select your goal',
//               ),
//               value: goal,
//               items: [
//                 DropdownMenuItem(
//                   value: "Lose Weight",
//                   child: Text("Lose Weight"),
//                 ),
//                 DropdownMenuItem(
//                   value: "Gain Weight",
//                   child: Text("Gain Weight"),
//                 ),
//                 DropdownMenuItem(
//                   value: "Maintain Weight",
//                   child: Text("Maintain Weight"),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   goal = value.toString();
//                   goalChanged = true;
//                 });
//               },
//             ),
//             SizedBox(height: 30.0),
//             ElevatedButton(
//               onPressed: () {
//                 updateUserDetails();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildInputRow(String label, TextEditingController controller, TextInputType keyboardType, Function(String) onChanged) {
//     return Row(
//       children: [
//         Container(
//           width: 100,
//           height: 40,
//           alignment: Alignment.centerLeft,
//           child: Text(
//             label,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               hintText: 'Enter your $label',
//             ),
//           ),
//         ),
//       ],
//     );
//   }



// import 'package:fitness_tracker_app/db/user_database.dart';
// import 'package:fitness_tracker_app/model/user.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class Settings extends StatefulWidget {
//   static String routeName = '/settings';
//   @override
//   _SettingsState createState() => _SettingsState();
// }
//
// class _SettingsState extends State<Settings> {
//
//   int age = 0;
//   double height = 0;
//   double weight = 0;
//   String goal = "";
//   bool goalChanged = false;
//
//   TextEditingController ageController = TextEditingController();
//   TextEditingController heightController = TextEditingController();
//   TextEditingController weightController = TextEditingController();
//
//   late User user;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fetchUser();
//   }
//
//   void _fetchUser() async {
//     final User tempUser = await UserDatabase.instance.getUser();
//     setState(() {
//       user = tempUser;
//       age = user.age;
//       height = user.height;
//       weight = user.weight;
//       goal = user.goal;
//     });
//   }
//
//   void updateUserDetails() async {
//
//     // User updatedUser = User(
//     //     name: user.name,
//     //     age: age,
//     //     weight: weight,
//     //     height: height,
//     //     goal: goal,
//     //     targetCalories: user.targetCalories,
//     //     currentCalories: user.currentCalories);
//
//     //await UserDatabase.instance.updateUserTest(user, age, weight, height, goal);
//     await UserDatabase.instance.updateUserDetails(user, age, weight, height, goal);
//
//     if(goalChanged) {
//
//       int calories;
//
//       int bmr = (88.362 + (13.397 * weight) + (4.799 * height ) - (5.677 * age)).round() ;
//
//       if (goal == "Lose Weight") {
//         calories = (bmr * 0.85).round();
//       } else if (goal == "Gain Weight") {
//         calories = (bmr * 1.15).round();
//       } else {
//         calories = bmr;
//       }
//
//       await UserDatabase.instance.updateUserTargetCalories(user, calories);
//     }
//
//     setState(() {
//       ageController.clear();
//       heightController.clear();
//       weightController.clear();
//     });
//
//     _fetchUser();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   height: 40,
//                   alignment: Alignment.center,
//                   child: Text('Age: $age', style: TextStyle(fontSize: 16),),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: TextFormField(
//                     controller: ageController,
//                     onChanged: (value) {
//                       setState(() {
//                         age = int.parse(value);
//                       });
//                     },
//                     decoration: InputDecoration(hintText: 'Enter your age'),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Container(
//                   height: 40,
//                   alignment: Alignment.center,
//                   child: Text('Weight: $weight', style: TextStyle(fontSize: 16),),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: TextFormField(
//                     controller: weightController,
//                     onChanged: (value) {
//                       setState(() {
//                         weight = double.parse(value);
//                       });
//                     },
//                     decoration: InputDecoration(hintText: 'Enter your weight'),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Container(
//                   height: 40,
//                   alignment: Alignment.center,
//                   child: Text('Height: $height', style: TextStyle(fontSize: 16),),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: TextFormField(
//                     controller: heightController,
//                     onChanged: (value) {
//                       setState(() {
//                         height = double.parse(value);
//                       });
//                     },
//                     decoration: InputDecoration(hintText: 'Enter your height'),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Container(
//                   height: 40,
//                   alignment: Alignment.center,
//                   child: Text('Goals: $goal', style: TextStyle(fontSize: 16),),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: DropdownButtonFormField(
//                     decoration: InputDecoration(
//                       labelText: goal,
//                       hintText: 'Select your goals'
//                     ),
//                     items: [
//                       DropdownMenuItem(
//                         value: "Lose Weight",
//                         child: Text("Lose Weight"),
//                       ),
//                       DropdownMenuItem(
//                         value: "Gain Weight",
//                         child: Text("Gain Weight"),
//                       ),
//                       DropdownMenuItem(
//                         value: "Maintain Weight",
//                         child: Text("Maintain Weight"),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       goal = value!;
//                       goalChanged = true;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30.0),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Update the user's details in SQLite
//                   updateUserDetails();
//                 },
//                 child: Text('Save'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

