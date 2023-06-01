
import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/food_log.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';

class CalorieTracker extends StatefulWidget {

  static String routeName = '/calorieTracker';
  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  final _formKey = GlobalKey<FormState>();

  String goal = "";
  double targetCalories = 0;
  double calories = 0;
  String foodName = "";
  String dateTimeStr = "";

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Tracker"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your daily calorie needs are ${user.targetCalories}.'),
              SizedBox(height: 16),
              Text('You have ${(user.targetCalories - user.currentCalories)} left.'),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Food/Meal",
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the food/meal";
                  }
                  return null;
                },
                onSaved: (value) {
                  foodName = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Calories",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the calories";
                  }
                  return null;
                },
                onSaved: (value) {
                  calories = double.parse(value!);
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    DateTime dateTime = DateTime.now();
                    dateTimeStr = dateTime.toString();

                    Food newFood = Food(
                        foodName: foodName,
                        calories: (user.currentCalories + calories),
                        dateTime: dateTimeStr
                    );

                    setState(() {
                      UserDatabase.instance.createFood(newFood);
                      UserDatabase.instance.updateUserCurrentCalories(user, (user.currentCalories + calories));
                    });

                    // Display the consumed calories to the user.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'You have consumed ${user.currentCalories} calories today'),
                      ),
                    );
                    setState(() {});
                  }
                },
                child: Text("Add"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

