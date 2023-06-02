import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/food_log.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalorieTracker extends StatefulWidget {
  static String routeName = '/calorieTracker';
  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  double targetCalories = 2000;
  double consumedCalories = 0;

  TextEditingController foodController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();

  List<Food> foodLogs = [];
  late User user;

  @override
  void initState() {
    super.initState();

    _fetchFoodLogs();
    _fetchUser();
  }

  void _fetchFoodLogs() async {
    final List<Food> logs = await UserDatabase.instance.readAllFood();
    setState(() {
      foodLogs = logs;
    });
  }

  void _fetchUser() async {
    final User tempUser = await UserDatabase.instance.getUser();
    setState(() {
      user = tempUser;
      targetCalories = user.targetCalories;
      consumedCalories = user.currentCalories;
    });
  }

  void _addFoodLog() async {
    final String foodName = foodController.text;
    final double calories = double.parse(caloriesController.text);

    DateTime dateTime = DateTime.now();
    String dateTimeStr = dateTime.toString();

    Food newFood =
        Food(foodName: foodName, calories: calories, dateTime: dateTimeStr);

    await UserDatabase.instance.createFood(newFood);
    //await UserDatabase.instance.updateUserCurrentCalories(user, (user.currentCalories + calories));

    // Retrieve the current consumedCalories value for the user
    double currentCalories = user.currentCalories;

    // Calculate the total calories of the newly added food
    double totalCalories = currentCalories + calories;

    // Update the consumedCalories column in the user data table with the updated value
    await UserDatabase.instance.updateUserCurrentCalories(user, totalCalories);
    //await updateConsumedCalories(totalCalories);

    setState(() {
      consumedCalories += calories;
      foodController.clear();
      caloriesController.clear();
    });

    _fetchFoodLogs();
  }

  // Future<void> addFood(String foodName, int calories) async {
  //   // Add the food and calories to the food log table in SQLite
  //
  //   // Retrieve the current consumedCalories value for the user
  //   int currentCalories = await retrieveConsumedCalories();
  //
  //   // Calculate the total calories of the newly added food
  //   int totalCalories = currentCalories + calories;
  //
  //   // Update the consumedCalories column in the user data table with the updated value
  //   await updateConsumedCalories(totalCalories);
  // }

// Function to retrieve the current consumedCalories value from the database
//   Future<int> retrieveConsumedCalories() async {
//     // Retrieve the current consumedCalories value from the database and return it
//   }

// Function to update the consumedCalories column in the user data table
  Future<void> updateConsumedCalories(double totalCalories) async {
    // Update the consumedCalories column in the user data table with the updated value
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Target Calories: $targetCalories',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            'Consumed Calories: $consumedCalories',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: foodController,
                    decoration: InputDecoration(labelText: 'Food'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Calories'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addFoodLog,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Food Log',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: foodLogs.length,
              itemBuilder: (context, index) {
                final log = foodLogs[index];
                return ListTile(
                  title: Text(log.foodName),
                  subtitle: Text('${log.calories} calories'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:fitness_tracker_app/db/user_database.dart';
// import 'package:fitness_tracker_app/model/food_log.dart';
// import 'package:fitness_tracker_app/model/user.dart';
// import 'package:flutter/material.dart';
//
// class CalorieTracker extends StatefulWidget {
//   static String routeName = '/calorieTracker';
//   @override
//   _CalorieTrackerState createState() => _CalorieTrackerState();
// }
//
// class _CalorieTrackerState extends State<CalorieTracker> {
//   final _formKey = GlobalKey<FormState>();
//
//   String goal = "";
//   double targetCalories = 0;
//   double calories = 0;
//   String foodName = "";
//   String dateTimeStr = "";
//
//   // late User user;
//   // late bool existUser = false;
//   // bool isLoading = false;
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //
//   //   refreshUser();
//   // }
//   //
//   // @override
//   // void dispose() {
//   //   UserDatabase.instance.close();
//   //
//   //   super.dispose();
//   // }
//   //
//   // Future refreshUser() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //
//   //   this.existUser = await UserDatabase.instance.checkUser();
//   //
//   //   if (existUser) {
//   //     this.user = await UserDatabase.instance.getUser();
//   //   } else
//   //     () {
//   //       this.existUser = false;
//   //     };
//   //
//   //   setState(() {
//   //     isLoading = false;
//   //   });
//   // }
//
//   Future refreshCalories(Food newFood, User user) async {
//     setState(() {});
//
//     await UserDatabase.instance.createFood(newFood);
//     await UserDatabase.instance
//         .updateUserCurrentCalories(user, (user.currentCalories + calories));
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User user = ModalRoute.of(context)!.settings.arguments as User;
//     double caloriesLeft = (user.targetCalories - user.currentCalories);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Calorie Tracker"),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                   'Your daily calorie needs are ${user.targetCalories}.'),
//               SizedBox(height: 16),
//               Text(
//                   'You have ${caloriesLeft} left.'),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: "Food/Meal",
//                 ),
//                 keyboardType: TextInputType.text,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter the food/meal";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   foodName = value!;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: "Calories",
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter the calories";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   calories = double.parse(value!);
//                 },
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//
//                     DateTime dateTime = DateTime.now();
//                     dateTimeStr = dateTime.toString();
//
//                     Food newFood = Food(
//                         foodName: foodName,
//                         calories: (user.currentCalories + calories),
//                         dateTime: dateTimeStr);
//
//                     refreshCalories(newFood, user);
//
//
//
//                     //refreshUser();
//                     // setState(() {
//                     //   UserDatabase.instance.createFood(newFood);
//                     //   UserDatabase.instance.updateUserCurrentCalories(user, (user.currentCalories + calories));
//                     // });
//
//                     // Display the consumed calories to the user.
//                     // ScaffoldMessenger.of(context).showSnackBar(
//                     //   SnackBar(
//                     //     content: Text(
//                     //         'You have consumed ${user.currentCalories} calories today'),
//                     //   ),
//                     // );
//                     //setState(() {});
//
//                     // if(existUser){
//                     //
//                     //
//                     //
//                     // }
//                     // else{
//                     //   ScaffoldMessenger.of(context).showSnackBar(
//                     //     SnackBar(
//                     //       content: Text(
//                     //           'Please input your details at Calorie Counter or reset the app'),
//                     //     ),
//                     //   );
//                     // }
//
//                   }
//                 },
//                 child: Text("Add"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
