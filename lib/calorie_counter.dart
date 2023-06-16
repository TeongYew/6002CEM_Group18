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
    //create a new user in the db
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
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    //check if the name text field is empty
                    //else return null
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
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    //check if the age text field is empty
                    //also check if the user inputs an invalid value
                    //else return null
                    if (value == null || value.isEmpty) {
                      return "Please enter your age";
                    }
                    else if (int.tryParse(value!) == null) {
                      return "Please enter your a valid number for your age";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    //set the local age variable
                    age = int.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Height (in cm)",
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    //check if the height text field is empty
                    //also check if the user inputs an invalid value
                    //else return null
                    if (value == null || value.isEmpty) {
                      return "Please enter your height";
                    }
                    else if (double.tryParse(value!) == null) {
                      return "Please enter your a valid number for your height";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    //set the local height variable
                    height = double.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Weight (in kg)",
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    //check if the weight text field is empty
                    //also check if the user inputs an invalid value
                    //else return null
                    if (value == null || value.isEmpty) {
                      return "Please enter your weight";
                    }
                    else if (int.tryParse(value!) == null) {
                      return "Please enter your a valid number for your weight";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    //set the local weight variable
                    weight = double.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Dietary Goal',
                    prefixIcon: Icon(Icons.fitness_center),
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
                  validator: (value) {
                    //check if the goal is unselected
                    //else return null
                    if (value == null || value.isEmpty) {
                      return "Please select a dietary goal";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    //set the local goal variable
                    goal = value!;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    //validate the form
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

                      //create a new user using the user's input
                      User newUser = User(
                        name: name,
                        age: age,
                        weight: weight,
                        height: height,
                        goal: goal,
                        targetCalories: targetCalories,
                        currentCalories: 0,
                      );

                      //run the function to create a new user
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

