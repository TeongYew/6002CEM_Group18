import 'package:fitness_tracker_app/calorie_tracker.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  static String routeName = '/settings';
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String name = '';
  int age = 0;
  double height = 0;
  double weight = 0;
  String goal = '';
  double targetCalories = 0;

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your current goal is: ${user.goal}'),
            SizedBox(height: 16),
            Text('Your current height is: ${user.height}'),
            SizedBox(height: 16),
            Text('Your current weight is: ${user.weight}'),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Show the edit dialog.
                showDialog(
                  context: context,
                  builder: (context) => EditDialog(),
                );
              },
              child: Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}


class EditDialog extends StatelessWidget {
  const EditDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Settings'),
      content: Form(
        key: CalorieTracker().key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Goal',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a goal';
                }
                return null;
              },
              onSaved: (value) {
                //CalorieTracker.of(context).fitnessGoal = value;
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
                  return 'Please enter a height';
                }
                return null;
              },
              onSaved: (value) {
                //CalorieTracker.of(context).height = double.parse(value!);
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
                  return 'Please enter a weight';
                }
                return null;
              },
              onSaved: (value) {
                //CalorieTracker.of(context).weight = double.parse(value!);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            //CalorieTracker().key.currentState.validate();
            //CalorieTracker().key.currentState.save();
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}



