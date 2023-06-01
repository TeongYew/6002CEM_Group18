import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/main_menu.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';
import 'dart:developer';


class CalorieCounter extends StatefulWidget {
  static String routeName = '/calorieCounter';

  @override
  State<CalorieCounter> createState() => _CalorieCounterState();
}

class _CalorieCounterState extends State<CalorieCounter> {
  final _formKey = GlobalKey<FormState>();


  String name = "";
  int age = 0;
  double height = 0;
  double weight = 0;
  String goal = "";
  double targetCalories = 0;

  // @override
  // void initState(){
  //   super.initState();
  //
  //   refreshUser();
  // }
  //
  // @override
  // void dispose(){
  //   UserDatabase.instance.close();
  //
  //   super.dispose();
  // }
  //
  // Future refreshUser() async {
  //   setState((){
  //     isLoading = true;
  //   });
  //
  //   this.users = await UserDatabase.instance.readAllUser();
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Counter"),
      ),
      body: Form(
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
              SizedBox(height: 16,),
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
                    //double targetCalories = 0;
                    if (goal == "Lose Weight") {
                      targetCalories =
                          655 + (9.6 * weight) - (4.8 * height) + (6.8 * age);
                    } else if (goal == "Gain Weight") {
                      targetCalories =
                          655 + (13.7 * weight) + (5.0 * height) - (6.8 * age);
                    } else {
                      targetCalories =
                          655 + (10 * weight) + (6.25 * height) - (5 * age);
                    }

                    User newUser = User(
                        name: name,
                        age: age,
                        weight: weight,
                        height: height,
                        goal: goal,
                        targetCalories: targetCalories,
                        currentCalories: 0.0);

                    UserDatabase.instance.createUser(newUser);

                    // Display the daily calorie needs to the user.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Your daily calorie needs are $targetCalories'),
                      ),
                    );

                    //send the user back to the main menu
                    Navigator.of(context).pushNamed(MainMenu.routeName);
                  }
                },
                child: Text("Calculate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
