import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/main_menu.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';

class CalorieCounter extends StatefulWidget {
  static String routeName = '/calorieCounter';

  @override
  State<CalorieCounter> createState() => _CalorieCounterState();
}

class _CalorieCounterState extends State<CalorieCounter> {

  void createNewUser(User newUser) async {
    await UserDatabase.instance.createUser(newUser);
  }

  final _formKey = GlobalKey<FormState>();

  String name = "";
  int age = 0;
  double height = 0;
  double weight = 0;
  String goal = "";
  int targetCalories = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Counter"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Age",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your age";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    age = int.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Height (in cm)",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your height";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    height = double.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Weight (in kg)",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your weight";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    weight = double.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Fitness Goal',
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
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Calculate the daily calorie needs based on the user's input.
                      int bmr = (88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)).round();

                      if (goal == "Lose Weight") {
                        targetCalories = (bmr * 0.85).round();
                      } else if (goal == "Gain Weight") {
                        targetCalories = (bmr * 1.15).round();
                      } else {
                        targetCalories = bmr;
                      }

                      User newUser = User(
                        name: name,
                        age: age,
                        weight: weight,
                        height: height,
                        goal: goal,
                        targetCalories: targetCalories,
                        currentCalories: 0,
                      );

                      createNewUser(newUser);

                      // Display the daily calorie needs to the user.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Your daily calorie needs are $targetCalories'),
                        ),
                      );

                      // Send the user back to the main menu
                      Navigator.of(context).pushNamed(MainMenu.routeName);
                    }
                  },
                  child: Text("Calculate"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//import 'package:fitness_tracker_app/db/user_database.dart';
// import 'package:fitness_tracker_app/main_menu.dart';
// import 'package:fitness_tracker_app/model/user.dart';
// import 'package:flutter/material.dart';
// import 'dart:developer';
//
//
// class CalorieCounter extends StatefulWidget {
//   static String routeName = '/calorieCounter';
//
//   @override
//   State<CalorieCounter> createState() => _CalorieCounterState();
// }
//
// class _CalorieCounterState extends State<CalorieCounter> {
//   final _formKey = GlobalKey<FormState>();
//
//   String name = "";
//   int age = 0;
//   double height = 0;
//   double weight = 0;
//   String goal = "";
//   int targetCalories = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Calorie Counter"),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: "Name",
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your name";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   name = value!;
//                 },
//               ),
//               SizedBox(height: 16,),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: "Age",
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your age";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   age = int.parse(value!);
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: "Height (in cm)",
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your height";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   height = double.parse(value!);
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: "Weight (in kg)",
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your weight";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   weight = double.parse(value!);
//                 },
//               ),
//               SizedBox(height: 16),
//               DropdownButtonFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Fitness Goal',
//                 ),
//                 items: [
//                   DropdownMenuItem(
//                     value: "Lose Weight",
//                     child: Text("Lose Weight"),
//                   ),
//                   DropdownMenuItem(
//                     value: "Gain Weight",
//                     child: Text("Gain Weight"),
//                   ),
//                   DropdownMenuItem(
//                     value: "Maintain Weight",
//                     child: Text("Maintain Weight"),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   goal = value!;
//                 },
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//
//                     // Calculate the daily calorie needs based on the user's input.
//                     //double targetCalories = 0;
//                     int bmr = (88.362 + (13.397 * weight) + (4.799 * height ) - (5.677 * age)).round() ;
//
//                     if (goal == "Lose Weight") {
//                       targetCalories = (bmr * 0.85).round();
//                     } else if (goal == "Gain Weight") {
//                       targetCalories = (bmr * 1.15).round();
//                     } else {
//                       targetCalories = bmr;
//                     }
//
//                     User newUser = User(
//                         name: name,
//                         age: age,
//                         weight: weight,
//                         height: height,
//                         goal: goal,
//                         targetCalories: targetCalories,
//                         currentCalories: 0);
//
//                     UserDatabase.instance.createUser(newUser);
//
//                     // Display the daily calorie needs to the user.
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             'Your daily calorie needs are $targetCalories'),
//                       ),
//                     );
//
//                     //send the user back to the main menu
//                     Navigator.of(context).pushNamed(MainMenu.routeName);
//                   }
//                 },
//                 child: Text("Calculate"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }