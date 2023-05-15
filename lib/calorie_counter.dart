import 'package:flutter/material.dart';


class CalorieCounter extends StatefulWidget {
  @override
  _CalorieCounterState createState() => _CalorieCounterState();
}

class _CalorieCounterState extends State<CalorieCounter> {
  final _formKey = GlobalKey<FormState>();

  int age = 0;
  double height = 0;
  double weight = 0;
  String fitnessGoal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Counter'),
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
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
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
                  labelText: 'Height (in cm)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
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
                  labelText: 'Weight (in kg)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
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
                    value: 'Lose Weight',
                    child: Text('Lose Weight'),
                  ),
                  DropdownMenuItem(
                    value: 'Gain Weight',
                    child: Text('Gain Weight'),
                  ),
                  DropdownMenuItem(
                    value: 'Maintain Weight',
                    child: Text('Maintain Weight'),
                  ),
                ],
                onChanged: (value) {
                  fitnessGoal = value!;
                },
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Calculate the daily calorie needs based on the user's input.
                    double dailyCalorieNeeds = 0;
                    if (fitnessGoal == 'Lose Weight') {
                      dailyCalorieNeeds =
                          655 + (9.6 * weight) - (4.8 * height) + (6.8 * age);
                    } else if (fitnessGoal == 'Gain Weight') {
                      dailyCalorieNeeds =
                          655 + (13.7 * weight) + (5.0 * height) - (6.8 * age);
                    } else {
                      dailyCalorieNeeds =
                          655 + (10 * weight) + (6.25 * height) - (5 * age);
                    }

                    // Display the daily calorie needs to the user.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Your daily calorie needs are $dailyCalorieNeeds'),
                      ),
                    );
                  }
                },
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

