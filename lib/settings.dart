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

    //get the user information
    fetchUser();
  }

  void fetchUser() async {
    //get the user information
    final User tempUser = await UserDatabase.instance.getUser();

    //refresh the page
    setState(() {
      //use the user information fetched from the db to set the necessary local variables
      user = tempUser;
      age = user.age;
      height = user.height;
      weight = user.weight;
      goal = user.goal;
    });
  }

  void updateUserDetails() async {
    //update the user's details
    await UserDatabase.instance.updateUserDetails(user, age, weight, height, goal);

    //calculate the calories based on the user's weight, height, age, and goal
    int calories;

    int bmr = (88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)).round();

    if (goal == "Lose Weight") {
      calories = (bmr * 0.85).round();
    } else if (goal == "Gain Weight") {
      calories = (bmr * 1.15).round();
    } else {
      calories = bmr;
    }

    //update the user's target calories
    await UserDatabase.instance.updateUserTargetCalories(user, calories);

    //refresh the page
    setState(() {
      //clear all the text fields
      ageController.clear();
      heightController.clear();
      weightController.clear();
    });

    fetchUser();
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
                  //refresh the page as changes are made
                  setState(() {
                    //update the age
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
                  //refresh the page as changes are made
                  setState(() {
                    //update the weight
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
                  //refresh the page as changes are made
                  setState(() {
                    //update the height
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
                  //refresh the page as changes are made
                  setState(() {
                    //update the goal and also set the goalChanged variable to true
                    goal = value.toString();
                    goalChanged = true;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Update the user's details
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
