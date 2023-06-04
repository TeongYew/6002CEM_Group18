import 'dart:math';

import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/food_log.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class CalorieTracker extends StatefulWidget {
  static String routeName = '/calorieTracker';

  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  int targetCalories = 0;
  int consumedCalories = 0;

  TextEditingController foodController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();

  List<Food> foodLogs = [];
  late User user;

  @override
  void initState() {
    super.initState();
    _fetchFoodLogsToday();
    _fetchUser();
  }

  void _fetchFoodLogsToday() async {
    DateTime dateTime = DateTime.now();
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    String dateStr = "$day/$month/$year";

    final List<Food> logs = await UserDatabase.instance.readFoodUsingDate(dateStr);
    setState(() {
      foodLogs = logs;
    });
    print('foodLogs: ${foodLogs.length}');
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
    final int calories = int.parse(caloriesController.text);

    DateTime dateTime = DateTime.now();
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString();
    String dateStr = "$day/$month/$year";
    String timeStr = "$hour:$minute";

    Food newFood = Food(
      foodName: foodName,
      calories: calories,
      date: dateStr,
      time: timeStr,
    );

    await UserDatabase.instance.createFood(newFood);
    int currentCalories = user.currentCalories;
    int totalCalories = currentCalories + calories;
    await UserDatabase.instance.updateUserCurrentCalories(user, totalCalories);

    setState(() {
      consumedCalories += calories;
      foodController.clear();
      caloriesController.clear();
    });

    _fetchUser();
    _fetchFoodLogsToday();
  }

  void resetConsumedCaloriesAndFoodToday() async {
    DateTime dateTime = DateTime.now();
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    String dateStr = "$day/$month/$year";

    await UserDatabase.instance.deleteAllFoodToday(dateStr);
    await UserDatabase.instance.updateUserCurrentCalories(user, 0);

    setState(() {
      consumedCalories = 0;
      foodController.clear();
      caloriesController.clear();
      foodLogs.clear();
    });

    _fetchUser();
    _fetchFoodLogsToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Calorie Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Target Calories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$targetCalories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Consumed Calories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$consumedCalories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: foodController,
              decoration: InputDecoration(
                labelText: 'Food',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calories',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addFoodLog,
              child: Text('Add'),
            ),
            SizedBox(height: 24),
            Text(
              'Food Log',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: foodLogs.length,
                itemBuilder: (context, index) {
                  final log = foodLogs[index];
                  return ListTile(
                    title: Text(
                      '${log.date} ${log.time}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${log.foodName}, ${log.calories} calories',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Reset Food Logs'),
              content: const Text('Are you sure you want to reset the food logs for today?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    resetConsumedCaloriesAndFoodToday();
                    Navigator.pop(context, 'Yes');
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.redo),
      ),
    );
  }
}





// import 'dart:math';
//
// import 'package:fitness_tracker_app/db/user_database.dart';
// import 'package:fitness_tracker_app/model/food_log.dart';
// import 'package:fitness_tracker_app/model/user.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class CalorieTracker extends StatefulWidget {
//   static String routeName = '/calorieTracker';
//
//   @override
//   _CalorieTrackerState createState() => _CalorieTrackerState();
// }
//
// class _CalorieTrackerState extends State<CalorieTracker> {
//   int targetCalories = 0;
//   int consumedCalories = 0;
//
//   TextEditingController foodController = TextEditingController();
//   TextEditingController caloriesController = TextEditingController();
//
//   List<Food> foodLogs = [];
//   late User user;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fetchFoodLogsToday();
//     _fetchUser();
//   }
//
//   void _fetchFoodLogs() async {
//     final List<Food> logs = await UserDatabase.instance.readAllFood();
//     setState(() {
//       foodLogs = logs;
//     });
//   }
//
//   void _fetchFoodLogsToday() async {
//     DateTime dateTime = DateTime.now();
//     String day = dateTime.day.toString();
//     String month = dateTime.month.toString();
//     String year = dateTime.year.toString();
//     String dateStr = "$day/$month/$year";
//
//     final List<Food> logs =
//     await UserDatabase.instance.readFoodUsingDate(dateStr);
//     setState(() {
//       foodLogs = logs;
//     });
//   }
//
//   void _fetchUser() async {
//     final User tempUser = await UserDatabase.instance.getUser();
//     setState(() {
//       user = tempUser;
//       targetCalories = user.targetCalories;
//       consumedCalories = user.currentCalories;
//     });
//   }
//
//   void _addFoodLog() async {
//     final String foodName = foodController.text;
//     final int calories = int.parse(caloriesController.text);
//
//     DateTime dateTime = DateTime.now();
//     String day = dateTime.day.toString();
//     String month = dateTime.month.toString();
//     String year = dateTime.year.toString();
//     String hour = dateTime.hour.toString();
//     String minute = dateTime.minute.toString();
//     String dateStr = "$day/$month/$year";
//     String timeStr = "$hour:$minute";
//
//     Food newFood = Food(
//         foodName: foodName, calories: calories, date: dateStr, time: timeStr);
//
//     await UserDatabase.instance.createFood(newFood);
//
//     int currentCalories = user.currentCalories;
//     int totalCalories = currentCalories + calories;
//
//     await UserDatabase.instance.updateUserCurrentCalories(user, totalCalories);
//
//     setState(() {
//       consumedCalories += calories;
//       foodController.clear();
//       caloriesController.clear();
//     });
//
//     _fetchUser();
//     _fetchFoodLogsToday();
//   }
//
//   void resetConsumedCaloriesAndFoodToday() async {
//     DateTime dateTime = DateTime.now();
//     String day = dateTime.day.toString();
//     String month = dateTime.month.toString();
//     String year = dateTime.year.toString();
//     String dateStr = "$day/$month/$year";
//
//     await UserDatabase.instance.deleteAllFoodToday(dateStr);
//     await UserDatabase.instance.updateUserCurrentCalories(user, 0);
//
//     setState(() {
//       consumedCalories = 0;
//       foodController.clear();
//       caloriesController.clear();
//       foodLogs.clear();
//     });
//
//     _fetchUser();
//     _fetchFoodLogsToday();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calorie Tracker'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             color: Colors.blueGrey[100],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Target Calories',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   '$targetCalories',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Consumed Calories',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   '$consumedCalories',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: foodLogs.length,
//               itemBuilder: (context, index) {
//                 final log = foodLogs[index];
//                 return ListTile(
//                   title: Text(
//                     '${log.date} ${log.time}',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     '${log.foodName}, ${log.calories} calories',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextField(
//                   controller: foodController,
//                   decoration: InputDecoration(
//                     labelText: 'Food',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: caloriesController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Calories',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _addFoodLog,
//                   child: Text('Add'),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog<String>(
//                       context: context,
//                       builder: (BuildContext context) => AlertDialog(
//                         title: const Text('Reset Food Logs'),
//                         content: const Text(
//                             'Are you sure you want to reset the food logs for today?'),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, 'Cancel'),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               resetConsumedCaloriesAndFoodToday();
//                               Navigator.pop(context, 'Yes');
//                             },
//                             child: const Text('Yes'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   child: Text('Reset Food Logs'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }










// import 'dart:math';
//
// import 'package:fitness_tracker_app/db/user_database.dart';
// import 'package:fitness_tracker_app/model/food_log.dart';
// import 'package:fitness_tracker_app/model/user.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class CalorieTracker extends StatefulWidget {
//   static String routeName = '/calorieTracker';
//   @override
//   _CalorieTrackerState createState() => _CalorieTrackerState();
// }
//
// class _CalorieTrackerState extends State<CalorieTracker> {
//   int targetCalories = 0;
//   int consumedCalories = 0;
//
//   TextEditingController foodController = TextEditingController();
//   TextEditingController caloriesController = TextEditingController();
//
//   List<Food> foodLogs = [];
//   late User user;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fetchFoodLogsToday();
//     _fetchUser();
//   }
//
//   void _fetchFoodLogs() async {
//     final List<Food> logs = await UserDatabase.instance.readAllFood();
//     setState(() {
//       foodLogs = logs;
//     });
//   }
//
//   void _fetchFoodLogsToday() async {
//     DateTime dateTime = DateTime.now();
//     String day = dateTime.day.toString();
//     String month = dateTime.month.toString();
//     String year = dateTime.year.toString();
//     String dateStr = "$day/$month/$year";
//
//     final List<Food> logs =
//     await UserDatabase.instance.readFoodUsingDate(dateStr);
//     setState(() {
//       foodLogs = logs;
//     });
//   }
//
//   void _fetchUser() async {
//     final User tempUser = await UserDatabase.instance.getUser();
//     setState(() {
//       user = tempUser;
//       targetCalories = user.targetCalories;
//       consumedCalories = user.currentCalories;
//     });
//   }
//
//   void _addFoodLog() async {
//     final String foodName = foodController.text;
//     final int calories = int.parse(caloriesController.text);
//
//     DateTime dateTime = DateTime.now();
//     String day = dateTime.day.toString();
//     String month = dateTime.month.toString();
//     String year = dateTime.year.toString();
//     String hour = dateTime.hour.toString();
//     String minute = dateTime.minute.toString();
//     String dateStr = "$day/$month/$year";
//     String timeStr = "$hour:$minute";
//
//     Food newFood = Food(
//         foodName: foodName, calories: calories, date: dateStr, time: timeStr);
//
//     await UserDatabase.instance.createFood(newFood);
//
//     int currentCalories = user.currentCalories;
//     int totalCalories = currentCalories + calories;
//
//     await UserDatabase.instance.updateUserCurrentCalories(user, totalCalories);
//
//     setState(() {
//       consumedCalories += calories;
//       foodController.clear();
//       caloriesController.clear();
//     });
//
//     _fetchUser();
//     _fetchFoodLogsToday();
//   }
//
//   void resetConsumedCaloriesAndFoodToday() async {
//     DateTime dateTime = DateTime.now();
//     String day = dateTime.day.toString();
//     String month = dateTime.month.toString();
//     String year = dateTime.year.toString();
//     String dateStr = "$day/$month/$year";
//
//     await UserDatabase.instance.deleteAllFoodToday(dateStr);
//     await UserDatabase.instance.updateUserCurrentCalories(user, 0);
//
//     setState(() {
//       consumedCalories = 0;
//       foodController.clear();
//       caloriesController.clear();
//       foodLogs.clear();
//     });
//
//     _fetchUser();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calorie Tracker'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             color: Colors.blueGrey[100],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Target Calories',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   '$targetCalories',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Consumed Calories',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   '$consumedCalories',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: foodLogs.length,
//               itemBuilder: (context, index) {
//                 final log = foodLogs[index];
//                 return ListTile(
//                   title: Text(
//                     '${log.date} ${log.time}',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     '${log.foodName}, ${log.calories} calories',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: foodController,
//                   decoration: InputDecoration(
//                     labelText: 'Food',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: caloriesController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Calories',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _addFoodLog,
//                   child: Text('Add'),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog<String>(
//                       context: context,
//                       builder: (BuildContext context) => AlertDialog(
//                         title: const Text('Reset Food Logs'),
//                         content: const Text('Are you sure you want to reset the food logs for today?'),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, 'Cancel'),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               resetConsumedCaloriesAndFoodToday();
//                               Navigator.pop(context, 'Yes');
//                             },
//                             child: const Text('Yes'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   child: Text('Reset Food Logs'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
// // import 'dart:math';
// //
// // import 'package:fitness_tracker_app/db/user_database.dart';
// // import 'package:fitness_tracker_app/model/food_log.dart';
// // import 'package:fitness_tracker_app/model/user.dart';
// // import 'package:flutter/material.dart';
// // import 'package:sqflite/sqflite.dart';
// // import 'package:path/path.dart';
// //
// // class CalorieTracker extends StatefulWidget {
// //   static String routeName = '/calorieTracker';
// //   @override
// //   _CalorieTrackerState createState() => _CalorieTrackerState();
// // }
// //
// // class _CalorieTrackerState extends State<CalorieTracker> {
// //   int targetCalories = 0;
// //   int consumedCalories = 0;
// //
// //   TextEditingController foodController = TextEditingController();
// //   TextEditingController caloriesController = TextEditingController();
// //
// //   List<Food> foodLogs = [];
// //   late User user;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     _fetchFoodLogsToday();
// //     _fetchUser();
// //   }
// //
// //   void _fetchFoodLogs() async {
// //     final List<Food> logs = await UserDatabase.instance.readAllFood();
// //     setState(() {
// //       foodLogs = logs;
// //     });
// //   }
// //
// //   void _fetchFoodLogsToday() async {
// //     DateTime dateTime = DateTime.now();
// //     String day = dateTime.day.toString();
// //     String month = dateTime.month.toString();
// //     String year = dateTime.year.toString();
// //     String dateStr = "$day/$month/$year";
// //
// //     final List<Food> logs =
// //         await UserDatabase.instance.readFoodUsingDate(dateStr);
// //     setState(() {
// //       foodLogs = logs;
// //     });
// //   }
// //
// //   void _fetchUser() async {
// //     final User tempUser = await UserDatabase.instance.getUser();
// //     setState(() {
// //       user = tempUser;
// //       targetCalories = user.targetCalories;
// //       consumedCalories = user.currentCalories;
// //     });
// //   }
// //
// //   void _addFoodLog() async {
// //     final String foodName = foodController.text;
// //     final int calories = int.parse(caloriesController.text);
// //
// //     DateTime dateTime = DateTime.now();
// //     String day = dateTime.day.toString();
// //     String month = dateTime.month.toString();
// //     String year = dateTime.year.toString();
// //     String hour = dateTime.hour.toString();
// //     String minute = dateTime.minute.toString();
// //     String dateStr = "$day/$month/$year";
// //     String timeStr = "$hour:$minute";
// //
// //     Food newFood = Food(
// //         foodName: foodName, calories: calories, date: dateStr, time: timeStr);
// //
// //     await UserDatabase.instance.createFood(newFood);
// //     //await UserDatabase.instance.updateUserCurrentCalories(user, (user.currentCalories + calories));
// //
// //     // Retrieve the current consumedCalories value for the user
// //     int currentCalories = user.currentCalories;
// //
// //     // Calculate the total calories of the newly added food
// //     int totalCalories = currentCalories + calories;
// //
// //     // Update the consumedCalories column in the user data table with the updated value
// //     await UserDatabase.instance.updateUserCurrentCalories(user, totalCalories);
// //     //await updateConsumedCalories(totalCalories);
// //
// //     setState(() {
// //       consumedCalories += calories;
// //       foodController.clear();
// //       caloriesController.clear();
// //     });
// //
// //     _fetchUser();
// //     _fetchFoodLogsToday();
// //   }
// //
// //   // Future<void> addFood(String foodName, int calories) async {
// //   //   // Add the food and calories to the food log table in SQLite
// //   //
// //   //   // Retrieve the current consumedCalories value for the user
// //   //   int currentCalories = await retrieveConsumedCalories();
// //   //
// //   //   // Calculate the total calories of the newly added food
// //   //   int totalCalories = currentCalories + calories;
// //   //
// //   //   // Update the consumedCalories column in the user data table with the updated value
// //   //   await updateConsumedCalories(totalCalories);
// //   // }
// //
// // // Function to retrieve the current consumedCalories value from the database
// // //   Future<int> retrieveConsumedCalories() async {
// // //     // Retrieve the current consumedCalories value from the database and return it
// // //   }
// //
// // // Function to update the consumedCalories column in the user data table
// //   void resetConsumedCaloriesAndFoodToday() async {
// //     DateTime dateTime = DateTime.now();
// //     String day = dateTime.day.toString();
// //     String month = dateTime.month.toString();
// //     String year = dateTime.year.toString();
// //     String dateStr = "$day/$month/$year";
// //
// //     // Update the consumedCalories column in the user data table with the updated value
// //     await UserDatabase.instance.deleteAllFoodToday(dateStr);
// //
// //     // Update the consumedCalories column in the user data table with the updated value
// //     await UserDatabase.instance.updateUserCurrentCalories(user, 0);
// //     //await updateConsumedCalories(totalCalories);
// //
// //     setState(() {
// //       consumedCalories = 0;
// //       foodController.clear();
// //       caloriesController.clear();
// //       foodLogs.clear();
// //     });
// //
// //     _fetchUser();
// //     //_fetchFoodLogsToday();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Calorie Tracker'),
// //       ),
// //       body: Column(
// //         children: [
// //           SizedBox(height: 20),
// //           Text(
// //             'Target Calories: $targetCalories',
// //             style: TextStyle(fontSize: 18),
// //           ),
// //           SizedBox(height: 20),
// //           Text(
// //             'Consumed Calories: $consumedCalories',
// //             style: TextStyle(fontSize: 18),
// //           ),
// //           SizedBox(height: 20),
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 16),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: foodController,
// //                     decoration: InputDecoration(labelText: 'Food'),
// //                   ),
// //                 ),
// //                 SizedBox(width: 10),
// //                 Expanded(
// //                   child: TextField(
// //                     controller: caloriesController,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(labelText: 'Calories'),
// //                   ),
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: _addFoodLog,
// //                   child: Text('Add'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 20),
// //           Text(
// //             'Food Log',
// //             style: TextStyle(fontSize: 18),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: foodLogs.length,
// //               itemBuilder: (context, index) {
// //                 final log = foodLogs[index];
// //                 return ListTile(
// //                   title: Text('${log.date} ${log.time}'),
// //                   subtitle: Text('${log.foodName}, ${log.calories} calories'),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //           onPressed: () {
// //             showDialog<String>(
// //               context: context,
// //               builder: (BuildContext context) => AlertDialog(
// //                 title: const Text('Reset food logs for today'),
// //                 content: const Text('Are you sure you want to reset the food logs for today?'),
// //                 actions: <Widget>[
// //                   TextButton(
// //                     onPressed: () => Navigator.pop(context, 'Cancel'),
// //                     child: const Text('Cancel'),
// //                   ),
// //                   TextButton(
// //                     onPressed: () {
// //                       resetConsumedCaloriesAndFoodToday();
// //                       Navigator.pop(context, 'Yes');
// //                     },
// //                     child: const Text('Yes'),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //           child: Icon(
// //             Icons.redo,
// //             color: Colors.white,
// //             size: 29,
// //           )),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// //     );
// //   }
// // }
// //
